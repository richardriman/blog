defmodule BlogWeb.UserControllerTest do
  use BlogWeb.ConnCase
  import Blog.AccountsFixtures
  alias Blog.Accounts

  @valid_attrs user_valid_attrs()
  @invalid_attrs user_invalid_attrs()

  defp test_user(conn) do
    post(conn, user_path(conn, :create), user: @valid_attrs)
  end

  describe "create user" do
    defp user_count(), do: Accounts.list_users() |> Enum.count()

    test "creates new user and redirects when there are no users", %{conn: conn} do
      conn = test_user(conn)
      assert redirected_to(conn) == page_path(conn, :index)
      assert get_flash(conn, :info) == "#{@valid_attrs.name} successfully registered!"
      assert Accounts.get_user_by_username(@valid_attrs.username).username == @valid_attrs.username
    end

    test "does not create user and renders errors when invalid", %{conn: conn} do
      count_before = user_count()
      conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "check the errors"
      assert user_count() == count_before
    end
  end

  test "does not allow user registration when there are already users", %{conn: conn} do
    conn = test_user(conn)
    Enum.each([
        get(conn, user_path(conn, :new)),
        post(conn, user_path(conn, :create, %{})),
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end)
  end

  test "new user shows new user page", %{conn: conn} do
    conn = get(conn, user_path(conn, :new))
    assert html_response(conn, :ok) =~ ~r/New User/s
  end
end
