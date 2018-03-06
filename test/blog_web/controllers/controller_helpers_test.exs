defmodule BlogWeb.PostControllerHelpersTest do
  use BlogWeb.ConnCase
  import Blog.PostsFixtures
  import BlogWeb.ControllerHelpers

  test "list_authorized_posts/1 lists only published posts", %{conn: conn} do
    conn = assign(conn, :current_user, nil)
    posts = [
      %{title: "post 1", body: "this is post 1.", published: true},
      %{title: "post 2", body: "this is post 2.", published: true},
      %{title: "post 3", body: "this is post 3.", published: false},
      %{title: "post 4", body: "this is post 4.", published: false}
    ]
    for post <- posts do
      post_fixture(post)
      if post.published do
        assert Enum.any?(list_authorized_posts(conn), fn p -> p.title == post.title end)
      end
    end
    assert Enum.count(list_authorized_posts(conn)) == 2
  end

  test "list_authorized_posts/1 lists all posts when user is logged in", %{conn: conn} do
    conn = login_as(conn, "user")
    posts = [
      %{title: "post 1", body: "this is post 1.", published: true},
      %{title: "post 2", body: "this is post 2.", published: true},
      %{title: "post 3", body: "this is post 3.", published: false},
      %{title: "post 4", body: "this is post 4.", published: false}
    ]
    for post <- posts do
      post_fixture(post)
      assert Enum.any?(list_authorized_posts(conn), fn p -> p.title == post.title end)
    end
    assert Enum.count(list_authorized_posts(conn)) == 4
  end
end
