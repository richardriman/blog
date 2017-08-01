defmodule PostControllerHelpersTest do
  use Blog.ConnCase
  import Blog.PostControllerHelpers

  test "get_post_list gets only published posts", %{conn: conn} do
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
        assert Enum.any?(get_post_list(conn), fn p -> p.title == post.title end)
      end
    end
    assert Enum.count(get_post_list(conn)) == 2
  end

  @tag login_as: "user"
  test "get_post_list gets all posts when user is logged in", %{conn: conn} do
    posts = [
      %{title: "post 1", body: "this is post 1.", published: true},
      %{title: "post 2", body: "this is post 2.", published: true},
      %{title: "post 3", body: "this is post 3.", published: false},
      %{title: "post 4", body: "this is post 4.", published: false}
    ]
    for post <- posts do
      insert_post(post)
      assert Enum.any?(get_post_list(conn), fn p -> p.title == post.title end)
    end
    assert Enum.count(get_post_list(conn)) == 4
  end
end