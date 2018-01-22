defmodule Blog.TestHelpers do
  
  defp gen_random_string(), do: Base.encode16(:crypto.strong_rand_bytes(8))

  def insert_user(attrs \\ %{}) do
    random = gen_random_string() 
    valid_attrs = %{name: "test user #{random}", username: "user#{random}", password: "secret#{random}"}

    {:ok, user} =
      attrs
      |> Enum.into(valid_attrs)
      |> Blog.Accounts.create_user()

    user
  end

  def insert_post(attrs \\ %{}) do
    random = gen_random_string()
    valid_attrs = %{title: "test post #{random}", body: "this is test post #{random}.", published: true}

    {:ok, post} =
      attrs
      |> Enum.into(valid_attrs)
      |> Blog.Posts.create_post()

    post
  end

  def gen_fixture_posts(num) do
    Enum.map(1..num, fn _n -> insert_post() end)
  end
end
