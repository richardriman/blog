defmodule BlogWeb.AuthTest do
  use BlogWeb.ConnCase
  alias BlogWeb.Auth

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(BlogWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "logged_in? returns false when no current_user exists", %{conn: conn} do
    assert Auth.logged_in?(conn) == false
  end

  test "logged_in? returns true when the current_user exists", %{conn: conn} do
    conn = assign(conn, :current_user, %Blog.Accounts.User{})
    assert Auth.logged_in?(conn) == true
  end

  test "login puts the user into the session", %{conn: conn} do
    login_conn =
      conn
      |> Auth.login(%Blog.Accounts.User{id: 123})
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == 123
  end

  test "logout drops the session", %{conn: conn} do
    logout_conn =
      conn
      |> put_session(:user_id, 123)
      |> Auth.logout()
      |> send_resp(:ok, "")

    next_conn = get(logout_conn, "/")
    refute get_session(next_conn, :user_id)
  end

  test "call places user from session into assigns", %{conn: conn} do
    user = insert_user()
    conn =
      conn
      |> put_session(:user_id, user.id)
      |> Auth.call(Repo)

    assert conn.assigns.current_user.id == user.id
  end

  test "call with no session sets current_user assign to nil", %{conn: conn} do
    conn = Auth.call(conn, Repo)
    assert conn.assigns.current_user == nil
  end

  test "login with a valid username and pass", %{conn: conn} do
    user = insert_user(%{username: "test", password: "secret"})
    {:ok, conn} = 
      Auth.login_by_username_and_pass(conn, "test", "secret", repo: Repo)

    assert conn.assigns.current_user.id == user.id
  end

  test "login with a not found user", %{conn: conn} do
    assert {:error, :not_found, _conn} = 
      Auth.login_by_username_and_pass(conn, "test", "secret", repo: Repo)
  end

  test "login with password mismatch", %{conn: conn} do
    _ = insert_user(%{username: "test", password: "secret"})
    assert {:error, :unauthorized, _conn} =
      Auth.login_by_username_and_pass(conn, "test", "wrong", repo: Repo)
  end

  test "init passes through opts" do
    assert Auth.init(key: "value") == [key: "value"]
  end
end
