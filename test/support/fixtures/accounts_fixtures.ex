defmodule Blog.AccountsFixtures do
  import Blog.TestHelpers

  def valid_attrs(), do: %{name: "test user", username: "user", password: "secret"}
  def invalid_attrs(), do: %{name: nil}

  def user_fixture(attrs \\ %{}) do
    random = gen_random_string() 
    valid_attrs = 
      valid_attrs()
      |> Enum.map(fn {k, v} -> {k, v <> random} end)
      |> Enum.into(%{})

    {:ok, user} =
      attrs
      |> Enum.into(valid_attrs)
      |> Blog.Accounts.create_user()

    user
  end
end