defmodule PhoenixBlog.PostControllerTest do
  use PhoenixBlog.ConnCase

  test "require user authentication for certain post actions", %{conn: conn} do
    Enum.each([
        get(conn, post_path(conn, :new)),
        get(conn, post_path(conn, :edit, "123")),
        get(conn, post_path(conn, :update, "123", %{})),
        get(conn, post_path(conn, :create, %{})),
        get(conn, post_path(conn, :delete, "123"))
      ], fn conn -> 
        assert html_response(conn, 302)
        assert conn.halted
      end)
  end
end