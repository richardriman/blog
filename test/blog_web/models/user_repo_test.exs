defmodule UserRepoTest do
  use Blog.ModelCase
  alias Blog.User

  @valid_attrs %{name: "John Doe", username: "test"}

  test "converts unique_constraint on username to error" do
    insert_user(%{username: "bob"})
    attrs = Map.put(@valid_attrs, :username, "bob")
    changeset = User.changeset(%User{}, attrs)
    assert {:error, changeset} = Repo.insert(changeset)
    assert {:username, {"has already been taken", []}} in changeset.errors
  end
end