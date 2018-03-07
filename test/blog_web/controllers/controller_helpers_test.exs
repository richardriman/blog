defmodule BlogWeb.PostControllerHelpersTest do
  use BlogWeb.ConnCase
  import Blog.PostsFixtures
  import BlogWeb.ControllerHelpers

  test "list_authorized_posts/1 lists only published posts", %{conn: conn} do
    conn = assign(conn, :current_user, nil)
    posts = [
      %{published: true},
      %{published: true},
      %{published: false},
      %{published: false}
    ] |> gen_post_fixtures()
    
    for post <- posts do
      if post.published do
        assert Enum.any?(list_authorized_posts(conn), fn p -> p.title == post.title end)
      else
        refute Enum.any?(list_authorized_posts(conn), fn p -> p.title == post.title end)
      end
    end
    assert Enum.count(list_authorized_posts(conn)) == 2
  end

  test "list_authorized_posts/1 lists all posts when user is logged in", %{conn: conn} do
    conn = login_as(conn, "user")
    posts = [
      %{published: true},
      %{published: true},
      %{published: false},
      %{published: false}
    ] |> gen_post_fixtures()

    for post <- posts do
      assert Enum.any?(list_authorized_posts(conn), fn p -> p.title == post.title end)
    end
    assert Enum.count(list_authorized_posts(conn)) == 4
  end
end
