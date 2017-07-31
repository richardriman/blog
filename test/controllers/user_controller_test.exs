defmodule UserControllerTest do
  use PhoenixBlog.ConnCase
  alias PhoenixBlog.User

  @valid_attrs %{name: "John Doe", username: "test", password: "secret"}
  @invalid_attrs %{}

  setup %{conn: conn} = config do
    if config[:test_user] do
      conn = post(conn, user_path(conn, :create), user: @valid_attrs)
      {:ok, conn: conn}
    else
      :ok
    end
  end

  defp user_count(query), do: Repo.one(from p in query, select: count(p.id))

  @tag test_user: true
  test "creates new user and redirects when there are no users", %{conn: conn} do
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) == "#{@valid_attrs.name} successfully registered!"
    lookup_attrs = Map.delete(@valid_attrs, :password)
    assert Repo.get_by!(User, lookup_attrs).username == @valid_attrs.username
  end

  @tag test_user: false
  test "does not create user and renders errors when invalid", %{conn: conn} do
    count_before = user_count(User)
    conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "check the errors"
    assert user_count(User) == count_before
  end

  @tag test_user: true
  test "does not allow user registration when there are already users", %{conn: conn} do
    Enum.each([
        get(conn, user_path(conn, :new)),
        post(conn, user_path(conn, :create, %{})),
      ], fn conn -> 
        assert html_response(conn, 302)
        assert conn.halted
      end)
  end

  @tag test_user: false
  test "shows new user page", %{conn: conn} do
    conn = get(conn, user_path(conn, :new))
    assert html_response(conn, :ok) =~ ~r/New User/s
  end
end