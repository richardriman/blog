defmodule Blog.AccountsTest do
  use Blog.ModelCase
  alias Blog.Accounts
  alias Blog.User

  @valid_attrs post_attrs() 
  @invalid_attrs %{title: nil}

  def valid_attrs(), do: @valid_attrs

  test "list_users/0 lists all users" do
    users = Enum.map(fixture_users(), fn u -> insert_user(u) end)

    result = Accounts.list_users()
    assert Accounts.list_users() == Enum.map(users, fn u -> %{u | password: nil} end) 
  end
end
