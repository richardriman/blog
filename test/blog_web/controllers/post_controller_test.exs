defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase
  import Blog.PostsFixtures
  alias Blog.Posts
  alias Blog.Posts.Post
  alias Blog.Repo

  @valid_attrs post_valid_attrs()
  @invalid_attrs post_invalid_attrs()
  @update_attrs post_update_attrs()

  test "require user authentication for certain post actions", %{conn: conn} do
    Enum.each([
        get(conn, post_path(conn, :new)),
        get(conn, post_path(conn, :edit, "123")),
        put(conn, post_path(conn, :update, "123", %{})),
        post(conn, post_path(conn, :create, %{})),
        delete(conn, post_path(conn, :delete, "123"))
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end)
  end

  describe "index" do
    test "handles no posts", %{conn: conn} do
      conn = get(conn, post_path(conn, :index))
      assert html_response(conn, 200) =~ ~r/None yet!/
    end

    test "lists only published posts", %{conn: conn} do
      posts = gen_post_fixtures(4)

      conn = get(conn, post_path(conn, :index))
      assert html_response(conn, 200) =~ ~r/Posts/
      posts
      |> Enum.filter(fn post -> post.published == true end)
      |> Enum.each(fn post -> assert String.contains?(conn.resp_body, post.title) end)
      posts
      |> Enum.filter(fn post -> post.published == false end)
      |> Enum.each(fn post-> refute String.contains?(conn.resp_body, post.title) end)
    end

    test "list all posts when logged in", %{conn: conn} do
      conn = login_as(conn, "user")
      posts = gen_post_fixtures(4)

      conn = get(conn, post_path(conn, :index))
      assert html_response(conn, 200) =~ ~r/Posts/
      for post <- posts do
        if post.published do
          assert String.contains?(conn.resp_body, post.title)
        else
          assert Regex.match?(~r/(#{post.title})(.*)(\(unpublished\))/s, conn.resp_body)
        end
      end
    end
  end

  describe "create post" do
    defp post_count(), do: Posts.list_posts() |> Enum.count()

    test "creates new post and redirects", %{conn: conn} do
      conn = login_as(conn, "user")
      conn = post(conn, post_path(conn, :create), post: @valid_attrs)
      assert redirected_to(conn) == post_path(conn, :index)
      assert Repo.get_by!(Post, @valid_attrs).title == @valid_attrs.title
    end

    test "does not create post and renders errors when invalid", %{conn: conn} do
      conn = login_as(conn, "user")
      count_before = post_count()
      conn = post(conn, post_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "check the errors"
      assert post_count() == count_before
    end
  end

  describe "show post" do
    test "does not show unpublished posts", %{conn: conn} do
      posts = [
        %{published: false},
        %{published: false}
      ] |> gen_post_fixtures()
      for post <- posts do
        conn = get(conn, post_path(conn, :show, post))
        assert redirected_to(conn) == post_path(conn, :index)
      end
    end

    test "creates new posts and shows them when user is logged in", %{conn: conn} do
      conn = login_as(conn, "user")
      posts = [
        %{published: true},
        %{published: false}
      ] |> gen_post_fixtures()
      for post <- posts do
        conn = get(conn, post_path(conn, :show, post))
        if post.published do
          assert html_response(conn, :ok) =~ ~r/#{post.body}/s
        else
          assert html_response(conn, :ok) =~ ~r/(#{post.title})(.*)(\(unpublished\))/s
        end
      end
    end
  end

  test "new shows post new page", %{conn: conn} do
    conn = login_as(conn, "user")
    conn = get(conn, post_path(conn, :new))
    assert html_response(conn, :ok) =~ ~r/New Post/s
  end

  test "edit shows post edit page", %{conn: conn} do
    conn = login_as(conn, "user")
    post = post_fixture(@valid_attrs)
    conn = get(conn, post_path(conn, :edit, post))
    assert html_response(conn, :ok) =~ ~r/Edit Post/s
  end

  describe "update post" do
    setup %{conn: conn} do
      {:ok, conn: login_as(conn, "user")}
    end

    test "updates existing post and redirects", %{conn: conn} do
      post = post_fixture(@valid_attrs)
      conn = put(conn, post_path(conn, :update, post), post: @update_attrs)
      assert html_response(conn, 302)
      assert Repo.get(Post, post.id).title == "new title"
    end

    test "does not update invalid post", %{conn: conn} do
      post = post_fixture(@valid_attrs)
      conn = put(conn, post_path(conn, :update, post), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "check the errors"
      assert Repo.get(Post, post.id).title == post.title
    end
  end

  test "delete post deletes existing post", %{conn: conn} do
    conn = login_as(conn, "user")
    post = post_fixture(@valid_attrs)
    conn = delete(conn, post_path(conn, :delete, post))
    assert html_response(conn, 302)
    refute Repo.get(Post, post.id)
  end
end
