defmodule PhoenixBlog.PostViewTest do
  use PhoenixBlog.ConnCase, async: true
  import Phoenix.View

  setup %{conn: conn} = config do
    post = %PhoenixBlog.Post{
        title: "test post",
        slug: "test-post", 
        body: "this is a test.", 
        published: true, 
        inserted_at: ~D[2017-01-01]
      }
    case config[:test_post] do
      true -> {:ok, conn: conn, post: post}
      opts when is_map(opts) ->
        {:ok, conn: conn, post: Map.merge(post, opts)}
      _ -> :ok
    end
  end

  test "renders index.html", %{conn: conn} do
    posts = [
      %PhoenixBlog.Post{
        title: "post 1", 
        slug: "post-1", 
        body: "this is post 1.", 
        published: true, 
        inserted_at: ~D[2016-01-01]},
      %PhoenixBlog.Post{
        title: "post 2", 
        slug: "post-2", 
        body: "this is post 2.", 
        published: true, 
        inserted_at: ~D[2016-01-02]
      }
    ]
    content = render_to_string(PhoenixBlog.PostView, "index.html", conn: conn, current_user: nil, posts: posts)
    assert String.contains?(content, "Posts")
    for post <- posts do
      assert String.contains?(content, post.title)
    end
  end

  test "renders index.html with unpublished posts", %{conn: conn} do
    posts = [
      %PhoenixBlog.Post{
        title: "post 1", 
        slug: "post-1", 
        body: "this is post 1.", 
        published: true, 
        inserted_at: ~D[2016-01-01]},
      %PhoenixBlog.Post{
        title: "post 2", 
        slug: "post-2", 
        body: "this is post 2.", 
        published: false, 
        inserted_at: ~D[2016-01-02]
      }
    ]
    content = render_to_string(PhoenixBlog.PostView, "index.html", conn: conn, current_user: nil, posts: posts)
    assert String.contains?(content, "Posts")
    for post <- posts do
      if post.published do
        assert String.contains?(content, post.title)
      else
        assert Regex.match?(~r/(#{post.title})(.*)(\(unpublished\))/s, content)
      end
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = PhoenixBlog.Post.changeset(%PhoenixBlog.Post{})
    content = render_to_string(PhoenixBlog.PostView, "new.html", conn: conn, changeset: changeset)
    assert String.contains?(content, "New Post")
  end

  @tag :test_post
  test "renders show.html", %{conn: conn, post: post} do
    content = render_to_string(PhoenixBlog.PostView, "show.html", conn: conn, current_user: nil, post: post)
    assert String.contains?(content, post.title)
  end

  @tag test_post: %{published: false}
  test "renders show.html with unpublished post", %{conn: conn, post: post} do
    content = render_to_string(PhoenixBlog.PostView, "show.html", conn: conn, current_user: nil, post: post)
    assert Regex.match?(~r/(#{post.title})(.*)(\(unpublished\))/s, content)
  end

  @tag :test_post
  test "renders edit.html", %{conn: conn, post: post} do
    changeset = PhoenixBlog.Post.changeset(%PhoenixBlog.Post{})
    content = render_to_string(PhoenixBlog.PostView, "edit.html", conn: conn, changeset: changeset, post: post)
    assert String.contains?(content, "Edit Post")
  end

  test "renders form.html", %{conn: conn} do
    changeset = PhoenixBlog.Post.changeset(%PhoenixBlog.Post{})
    content = render_to_string(PhoenixBlog.PostView, "form.html", conn: conn, changeset: changeset, action: nil)
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

    html = PhoenixBlog.PostView.get_formatted_post(post)
    assert String.contains?(html, "<table class=\"pure-table\">")
  end
end