defmodule PhoenixBlog.PostViewTest do
  use PhoenixBlog.ConnCase, async: true
  import Phoenix.View

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
    content = render_to_string(PhoenixBlog.PostView, "index.html", conn: conn, posts: posts, current_user: nil)
    assert String.contains?(content, "Posts")
    for post <- posts do
      assert String.contains?(content, post.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = PhoenixBlog.Post.changeset(%PhoenixBlog.Post{})
    content = render_to_string(PhoenixBlog.PostView, "new.html", conn: conn, changeset: changeset)

    assert String.contains?(content, "New Post")
  end
end