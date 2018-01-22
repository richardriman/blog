defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

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

  test "handle no posts on index", %{conn: conn} do
    conn = get(conn, post_path(conn, :index))
    assert html_response(conn, 200) =~ ~r/None yet!/
  end

  test "list only published posts on index", %{conn: conn} do
    posts = gen_fixture_posts(4)

    conn = get(conn, post_path(conn, :index))
    assert html_response(conn, 200) =~ ~r/Posts/
    posts
    |> Enum.filter(fn post -> post.published == true end)
    |> Enum.each(fn post -> assert String.contains?(conn.resp_body, post.title) end)
    posts
    |> Enum.filter(fn post -> post.published == false end)
    |> Enum.each(fn post-> refute String.contains?(conn.resp_body, post.title) end)
  end

  @tag login_as: "user"
  test "list all posts on index when logged in", %{conn: conn} do
    posts = gen_fixture_posts(4)

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

  alias Blog.Posts.Post
  @valid_attrs %{title: "test post", body: "some cool text.", published: true}
  @invalid_attrs %{title: "invalid post"}

  defp post_count(query), do: Repo.one(from p in query, select: count(p.id))

  @tag login_as: "user"
  test "creates new post and redirects", %{conn: conn} do
    conn = post(conn, post_path(conn, :create), post: @valid_attrs)
    assert redirected_to(conn) == post_path(conn, :index)
    assert Repo.get_by!(Post, @valid_attrs).title == @valid_attrs.title
  end

  @tag login_as: "user"
  test "does not create post and renders errors when invalid", %{conn: conn} do
    count_before = post_count(Post)
    conn = post(conn, post_path(conn, :create), post: @invalid_attrs)
    assert html_response(conn, 200) =~ "check the errors"
    assert post_count(Post) == count_before
  end

  test "does not show unpublished posts", %{conn: conn} do
    posts = [
      %{title: "post 1", body: "this is post 1.", published: false},
      %{title: "post 2", body: "this is post 2.", published: false}
    ]
    for post <- posts do
      inserted_post = insert_post(post)
      conn = get(conn, post_path(conn, :show, inserted_post))
      assert redirected_to(conn) == post_path(conn, :index)
    end
  end

  @tag login_as: "user"
  test "creates new posts and shows them when user is logged in", %{conn: conn} do
    posts = [
      %{title: "post 1", body: "this is post 1.", published: true},
      %{title: "post 2", body: "this is post 2.", published: false}
    ]
    for post <- posts do
      inserted_post = insert_post(post)
      conn = get(conn, post_path(conn, :show, inserted_post))
      if post.published do
        assert html_response(conn, :ok) =~ ~r/#{post.body}/s
      else
        assert html_response(conn, :ok) =~ ~r/(#{post.title})(.*)(\(unpublished\))/s
      end
    end
  end

  @tag login_as: "user"
  test "new shows post new page", %{conn: conn} do
    conn = get(conn, post_path(conn, :new))
    assert html_response(conn, :ok) =~ ~r/New Post/s
  end

  @tag login_as: "user"
  test "edit shows post edit page", %{conn: conn} do
    post = insert_post(@valid_attrs)
    conn = get(conn, post_path(conn, :edit, post))
    assert html_response(conn, :ok) =~ ~r/Edit Post/s
  end

  @tag login_as: "user"
  test "updates existing post and redirects", %{conn: conn} do
    post = insert_post(@valid_attrs)
    conn = put(conn, post_path(conn, :update, post), post: %{title: "new title"})
    assert html_response(conn, 302)
    assert Repo.get(Post, post.id).title == "new title"
  end

  @tag login_as: "user"
  test "does not update invlaid post", %{conn: conn} do
    post = insert_post(@valid_attrs)
    conn = put(conn, post_path(conn, :update, post), post: %{title: ""})
    assert html_response(conn, 200) =~ "check the errors"
    assert Repo.get(Post, post.id).title == post.title
  end

  @tag login_as: "user"
  test "deletes existing post", %{conn: conn} do
    post = insert_post(@valid_attrs)
    conn = delete(conn, post_path(conn, :delete, post))
    assert html_response(conn, 302)
    refute Repo.get(Post, post.id)
  end
end
