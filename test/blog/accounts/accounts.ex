defmodule Blog.AccountsTest do
  use Blog.ModelCase
  alias Blog.Accounts
  alias Blog.User

  @valid_attrs post_attrs() 

  def valid_attrs(), do: @valid_attrs

  test "list_users/0 lists all users" do
    users = Enum.map(1..4, fn _n -> insert_user() end)
    assert Accounts.list_users() == Enum.map(users, fn u -> %{u | password: nil} end) 
  end
end
