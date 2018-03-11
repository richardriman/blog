defmodule BlogWeb.AuthTest do
  use BlogWeb.ConnCase
  import Blog.AccountsFixtures
  alias BlogWeb.Auth

  setup %{conn: conn} do
    {:ok, conn: bypass_browser(conn)}
  end

  describe "logged_in?/1" do
    test "returns false when no current_user exists", %{conn: conn} do
      assert Auth.logged_in?(conn) == false
    end

    test "returns true when the current_user exists", %{conn: conn} do
      conn = assign(conn, :current_user, %Blog.Accounts.User{})
      assert Auth.logged_in?(conn) == true
    end
  end

  test "logout/0 drops the session", %{conn: conn} do
    logout_conn =
      conn
      |> put_session(:user_id, 123)
      |> Auth.logout()
      |> send_resp(:ok, "")

    next_conn = get(logout_conn, "/")
    refute get_session(next_conn, :user_id)
  end

  describe "call/2" do
    test "places user from session into assigns", %{conn: conn} do
      user = user_fixture()
      conn =
        conn
        |> put_session(:user_id, user.id)
        |> Auth.call([])

      assert conn.assigns.current_user.id == user.id
    end

    test "with no session sets current_user assign to nil", %{conn: conn} do
      conn = Auth.call(conn, [])
      assert conn.assigns.current_user == nil
    end
  end

  describe "login/2" do
    test "puts the user into the session", %{conn: conn} do
      login_conn =
        conn
        |> Auth.login(%Blog.Accounts.User{id: 123})
        |> send_resp(:ok, "")

      next_conn = get(login_conn, "/")
      assert get_session(next_conn, :user_id) == 123
    end
  end

  describe "login_by_username_and_pass/3" do
    test " with a valid username and pass assigns the user id", %{conn: conn} do
      user = user_fixture(%{username: "test", password: "secret"})
      {:ok, conn} =
        Auth.login_by_username_and_pass(conn, "test", "secret")

      assert conn.assigns.current_user.id == user.id
    end

    test "with a not found user", %{conn: conn} do
      assert {:error, :not_found, _conn} =
        Auth.login_by_username_and_pass(conn, "test", "secret")
    end

    test "with password mismatch", %{conn: conn} do
      _ = user_fixture(%{username: "test", password: "secret"})
      assert {:error, :unauthorized, _conn} =
        Auth.login_by_username_and_pass(conn, "test", "wrong")
    end
  end

  test "init/1 passes through opts" do
    assert Auth.init(key: "value") == [key: "value"]
  end
end
