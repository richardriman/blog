defmodule BlogWeb.SessionControllerTest do
  use BlogWeb.ConnCase
  import Blog.AccountsFixtures

  test "new session shows new session page", %{conn: conn} do
    conn = get(conn, session_path(conn, :new))
    assert html_response(conn, :ok) =~ ~r/Login/s
  end

  describe "create session" do
    test "creates a new session", %{conn: conn} do
      user = user_fixture()
      params = %{"session" => %{"username" => user.username, "password" => user.password}}
      conn = post(conn, session_path(conn, :create, params))
      assert get_flash(conn, :info) == "Welcome back!"
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "does not create a new session with invalid params", %{conn: conn} do
      user = user_fixture()
      params = %{"session" => %{"username" => user.username, "password" => "wrong"}}
      conn = post(conn, session_path(conn, :create, params))
      assert get_flash(conn, :error) == "Invalid username/password combination"
      assert html_response(conn, 200)
    end

    test "creates a new session and correctly sets the session and assigns", %{conn: conn} do
      user = user_fixture()
      params = %{"session" => %{"username" => user.username, "password" => user.password}}
      conn = post(conn, session_path(conn, :create, params))
      assert get_session(conn, :user_id) == user.id
      assert conn.assigns.current_user == %{user | password: nil}
    end
  end

  test "delete session logs out of current session", %{conn: conn} do
    user = user_fixture()
    params = %{"session" => %{"username" => user.username, "password" => user.password}}
    conn = post(conn, session_path(conn, :create, params))
    conn = delete(conn, session_path(conn, :delete, conn.assigns.current_user))
    assert redirected_to(conn) == page_path(conn, :index)
    refute conn.assigns.current_user == nil
    next_conn = get(conn, "/")
    refute get_session(next_conn, :user_id)
  end
end
