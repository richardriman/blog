defmodule BlogWeb.PostControllerHelpersTest do
  use BlogWeb.ConnCase
  import BlogWeb.ControllerHelpers

  test "list_authorized_posts lists only published posts", %{conn: conn} do
    conn = assign(conn, :current_user, nil)
    posts = [
      %{title: "post 1", body: "this is post 1.", published: true},
      %{title: "post 2", body: "this is post 2.", published: true},
      %{title: "post 3", body: "this is post 3.", published: false},
      %{title: "post 4", body: "this is post 4.", published: false}
    ]
    for post <- posts do
      insert_post(post)
      if post.published do
        assert Enum.any?(list_authorized_posts(conn), fn p -> p.title == post.title end)
      end
    end
    assert Enum.count(list_authorized_posts(conn)) == 2
  end

  @tag login_as: "user"
  test "list_authorized_posts lists all posts when user is logged in", %{conn: conn} do
    posts = [
      %{title: "post 1", body: "this is post 1.", published: true},
      %{title: "post 2", body: "this is post 2.", published: true},
      %{title: "post 3", body: "this is post 3.", published: false},
      %{title: "post 4", body: "this is post 4.", published: false}
    ]
    for post <- posts do
      insert_post(post)
      assert Enum.any?(list_authorized_posts(conn), fn p -> p.title == post.title end)
    end
    assert Enum.count(list_authorized_posts(conn)) == 4
  end
end