defmodule PhoenixBlog.PostControllerTest do
  use PhoenixBlog.ConnCase

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(username: username)
      conn = assign(conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "require user authentication for certain post actions", %{conn: conn} do
    Enum.each([
        get(conn, post_path(conn, :new)),
        get(conn, post_path(conn, :edit, "123")),
        put(conn, post_path(conn, :update, "123", %{})),
        post(conn, post_path(conn, :create, %{})),
        delete(conn, post_path(conn, :delete, "123"))
      ], fn conn -> 
        assert html_response(conn, 302)
        assert conn.halted
      end)
  end

  test "list only published posts on index", %{conn: conn} do
    posts = [
      %{title: "post 1", body: "this is post 1.", published: true},
      %{title: "post 2", body: "this is post 2.", published: true},
      %{title: "post 3", body: "this is post 3.", published: false},
      %{title: "post 4", body: "this is post 4.", published: false}
    ]

    for post <- posts do
      insert_post(post)
    end

    conn = get(conn, post_path(conn, :index))
    assert html_response(conn, 200) =~ ~r/Posts/
    posts
    |> Enum.filter(fn post -> post.published == true end)
    |> Enum.each(fn post -> assert String.contains?(conn.resp_body, post.title) end)
    posts
    |> Enum.filter(fn post -> post.published == false end)
    |> Enum.each(fn post-> refute String.contains?(conn.resp_body, post.title) end)
  end
end