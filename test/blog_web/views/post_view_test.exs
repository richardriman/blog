defmodule BlogWeb.PostViewTest do
  use BlogWeb.ConnCase, async: true
  import Phoenix.View
  import Blog.PostsFixtures

  setup context do
    if context[:populate_endpoint] do
      conn = 
        context.conn 
        |> bypass_through(BlogWeb.Router, [:browser]) 
        |> get("/")
      [conn: conn]
    else 
      :ok
    end
  end

  describe "index.html" do
    test "renders index.html", %{conn: conn} do
      posts = [
        %Blog.Posts.Post{
          title: "post 1", 
          slug: "post-1", 
          body: "this is post 1.", 
          published: true, 
          inserted_at: ~D[2016-01-01]},
        %Blog.Posts.Post{
          title: "post 2", 
          slug: "post-2", 
          body: "this is post 2.", 
          published: true, 
          inserted_at: ~D[2016-01-02]
        }
      ]
      content = render_to_string(BlogWeb.PostView, "index.html", conn: conn, current_user: nil, posts: posts)
      assert String.contains?(content, "Posts")
      for post <- posts do
        assert String.contains?(content, post.title)
      end
    end

    test "renders index.html with unpublished posts", %{conn: conn} do
      posts = [
        %Blog.Posts.Post{
          title: "post 1", 
          slug: "post-1", 
          body: "this is post 1.", 
          published: true, 
          inserted_at: ~D[2016-01-01]},
        %Blog.Posts.Post{
          title: "post 2", 
          slug: "post-2", 
          body: "this is post 2.", 
          published: false, 
          inserted_at: ~D[2016-01-02]
        }
      ]
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

  @tag :populate_endpoint
  test "renders new.html", %{conn: conn} do
    changeset = Blog.Posts.Post.changeset(%Blog.Posts.Post{})
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

  @tag :populate_endpoint
  test "renders edit.html", %{conn: conn} do
    post = post_fixture()
    changeset = Blog.Posts.Post.changeset(%Blog.Posts.Post{})
    content = render_to_string(BlogWeb.PostView, "edit.html", conn: conn, changeset: changeset, post: post)
    assert String.contains?(content, "Edit Post")
  end

  @tag :populate_endpoint
  test "renders form.html", %{conn: conn} do
    changeset = Blog.Posts.Post.changeset(%Blog.Posts.Post{})
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
