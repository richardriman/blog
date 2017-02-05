defmodule UserControllerTest do
  use PhoenixBlog.ConnCase
  alias PhoenixBlog.User

  setup config do
    if config[:user_registration] do
      Application.put_env(:phoenix_blog, :user_registration, true)
      :ok
    else
      Application.put_env(:phoenix_blog, :user_registration, false)
      :ok
    end
  end

  @valid_attrs %{name: "John Doe", username: "test", password: "secret"}
  @invalid_attrs %{}

  defp user_count(query), do: Repo.one(from p in query, select: count(p.id))

  @tag user_registration: true
  test "creates new user and redirects when registration enabled", %{conn: conn} do
    conn = post(conn, user_path(conn, :create), user: @valid_attrs)
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) == "#{@valid_attrs.name} successfully registered!"
    lookup_attrs = Map.delete(@valid_attrs, :password)
    assert Repo.get_by!(User, lookup_attrs).username == @valid_attrs.username
  end

  @tag user_registration: true
  test "does not create post and renders errors when invalid when registration enabled", %{conn: conn} do
    count_before = user_count(User)
    conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "check the errors"
    assert user_count(User) == count_before
  end

  @tag user_registration: false
  test "does not allow user registration when disabled", %{conn: conn} do
    Enum.each([
        get(conn, user_path(conn, :new)),
        post(conn, user_path(conn, :create, %{})),
      ], fn conn -> 
        assert html_response(conn, 302)
        assert conn.halted
      end)
  end
end