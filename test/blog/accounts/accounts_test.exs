defmodule Blog.AccountsTest do
  use Blog.ModelCase
  alias Blog.Accounts
  alias Blog.User

  @valid_attrs %{name: "test user", username: "user", password: "secret"}
  @invalid_attrs %{name: nil}

  test "list_users/0 lists all users" do
    users = Enum.map(1..4, fn _n -> insert_user() end)
    assert Accounts.list_users() == Enum.map(users, fn u -> %{u | password: nil} end) 
  end

  describe "create_user/1" do
    test "with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.username == @valid_attrs.username
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "converts unique_constraint on username to error" do
      insert_user(%{name: "a cool user", username: "user123", password: "secret"})
      attrs = Map.put(@valid_attrs, :username, "user123")
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(attrs) 
      assert {:username, {"has already been taken", []}} in changeset.errors
    end

    test "with valid attributes hashes password" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.password_hash
      assert @valid_attrs.password != user.password_hash
      assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, user.password_hash)
    end
  end
end
