defmodule Blog.AccountsTest do
  use Blog.DataCase
  import Blog.AccountsFixtures
  alias Blog.Accounts
  alias Blog.Accounts.User

  @valid_attrs valid_attrs()
  @invalid_attrs invalid_attrs()

  test "list_users/0 lists all users" do
    users = Enum.map(1..4, fn _n -> user_fixture() end)
    assert Accounts.list_users() == Enum.map(users, fn u -> %{u | password: nil} end) 
  end

  describe "get_user/1" do
    test "returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user(user.id) == %{user | password: nil}
    end

    test "with invalid data returns nil" do
      assert Accounts.get_user(123) == nil
    end
  end

  describe "get_user_by_username/1" do
    test "returns the user with given username" do
      user = user_fixture()
      assert Accounts.get_user_by_username(user.username) == %{user | password: nil}
    end

    test "with invalid data returns nil" do
      assert Accounts.get_user_by_username("wrong") == nil
    end
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
      user_fixture(%{name: "a cool user", username: "user123", password: "secret"})
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

  test "change_user/1 returns a user changeset" do
    user = user_fixture(@valid_attrs)
    assert %Ecto.Changeset{} = Accounts.change_user(user)
  end
end
