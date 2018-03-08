defmodule BlogWeb.PostControllerHelpersTest do
  use BlogWeb.ConnCase
  import Blog.PostsFixtures
  import BlogWeb.ControllerHelpers

  setup do
    posts = varied_published_post_attrs() |> gen_post_fixtures()

    {:ok, posts: posts}
  end
  
  test "list_authorized_posts/1 lists all posts when user is logged in", %{conn: conn, posts: posts} do
    conn = login_as(conn, "user")
    assert list_authorized_posts(conn) == posts
  end

  test "list_authorized_posts/1 lists only published posts when user is not logged in", %{conn: conn, posts: posts} do
    conn = assign(conn, :current_user, nil)
    result = list_authorized_posts(conn)
    published = Enum.filter(posts, fn p -> p.published == true end) 
    unpublished = Enum.filter(posts, fn p -> p.published == false end)

    assert result == published

    for post <- unpublished do
      refute Enum.any?(result, fn p -> p.title == post.title end) == true
    end
  end
end
