defmodule PhoenixBlog.PageViewTest do
  use PhoenixBlog.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    post = %PhoenixBlog.Post{
        title: "test post",
        slug: "test-post", 
        body: "this is a test.", 
        published: true, 
        inserted_at: ~D[2017-01-01]
      }
    content = render_to_string(PhoenixBlog.PageView, "index.html", conn: conn, latest_post: post)
    assert String.contains?(content, "John Joseph Sweeney")
    assert String.contains?(content, post.title)
  end

  test "renders index.html with unpublished posts", %{conn: conn} do
    post = %PhoenixBlog.Post{
        title: "test post",
        slug: "test-post", 
        body: "this is a test.", 
        published: false, 
        inserted_at: ~D[2017-01-01]
      }
    content = render_to_string(PhoenixBlog.PageView, "index.html", conn: conn, latest_post: post)
    assert String.contains?(content, "John Joseph Sweeney")
    assert String.contains?(content, post.title)
    assert String.contains?(content, "#{post.title} (unpublished)")
  end
end
