defmodule BlogWeb.PostViewTest do
  use BlogWeb.ConnCase, async: true
  import Phoenix.View
  import Blog.PostsFixtures

  describe "index.html" do
    test "renders index.html", %{conn: conn} do
      posts = gen_post_fixtures(4)
      content = render_to_string(BlogWeb.PostView, "index.html", conn: conn, current_user: nil, posts: posts)
      assert String.contains?(content, "Posts")
      for post <- posts do
        assert String.contains?(content, post.title)
      end
    end

    test "renders index.html with unpublished posts", %{conn: conn} do
      posts = [
        %{published: true},
        %{published: false}
      ] |> gen_post_fixtures()
      content = render_to_string(BlogWeb.PostView, "index.html", conn: conn, current_user: nil, posts: posts)
      assert String.contains?(content, "Posts")
      for post <- posts do
        if post.published do
          assert String.contains?(content, post.title)
        else
          assert Regex.match?(~r/(#{post.title})(.*)(\(unpublished\))/s, content)
        end
      end
    end
  end

  test "renders new.html", %{conn: conn} do
    conn = bypass_browser(conn)
    changeset = Blog.Posts.change_post(%Blog.Posts.Post{})
    content = render_to_string(BlogWeb.PostView, "new.html", conn: conn, changeset: changeset)
    assert String.contains?(content, "New Post")
  end

  describe "show.html" do
    test "renders", %{conn: conn} do
      post = post_fixture()
      content = render_to_string(BlogWeb.PostView, "show.html", conn: conn, current_user: nil, post: post)
      assert String.contains?(content, post.title)
    end

    test "renders with unpublished post", %{conn: conn} do
      post = post_fixture(%{published: false})
      content = render_to_string(BlogWeb.PostView, "show.html", conn: conn, current_user: nil, post: post)
      assert Regex.match?(~r/(#{post.title})(.*)(\(unpublished\))/s, content)
    end
  end

  test "renders edit.html", %{conn: conn} do
    conn = bypass_browser(conn)
    post = post_fixture()
    changeset = Blog.Posts.change_post(%Blog.Posts.Post{})
    content = render_to_string(BlogWeb.PostView, "edit.html", conn: conn, changeset: changeset, post: post)
    assert String.contains?(content, "Edit Post")
  end

  test "renders form.html", %{conn: conn} do
    conn = bypass_browser(conn)
    changeset = Blog.Posts.change_post(%Blog.Posts.Post{})
    content = render_to_string(BlogWeb.PostView, "form.html", conn: conn, changeset: changeset, action: nil)
    for word <- ["Title", "Body", "Published"], do: assert String.contains?(content, word)
  end

  test "correctly fixes markdown tables" do
    post = %{body: ~s"""
      | a   | simple | table |
      | --- | ------ | ----- |
      | col | col    | col   |
      | col | col    | col   |
      | col | col    | col   |
      """}

    html = BlogWeb.PostView.get_formatted_post(post)
    assert String.contains?(html, "<table class=\"pure-table\">")
  end
end
