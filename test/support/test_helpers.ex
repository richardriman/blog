defmodule Blog.TestHelpers do
  
  # TODO: move these into their own context modules and use the context functions instead of accessing the repo directly

  @valid_post_attrs %{title: "test post", body: "this is a test post.", published: true}
  def post_attrs(), do: @valid_post_attrs

  def insert_user(attrs \\ %{}) do
    random = Base.encode16(:crypto.strong_rand_bytes(8))

    valid_attrs = %{name: "test user #{random}", username: "user#{random}", password: "secret#{random}"}

    {:ok, user} =
      attrs
      |> Enum.into(valid_attrs)
      |> Blog.Accounts.create_user()

    user
  end

  # TODO: use a random seed like insert_user/1 and remove fixture_posts/0
  def insert_post(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(@valid_post_attrs)
      |> Blog.Posts.create_post()

    post
  end

  def fixture_posts() do
    [
      %{title: "post 1", body: "this is post 1.", published: true},
      %{title: "post 2", body: "this is post 2.", published: true},
      %{title: "post 3", body: "this is post 3.", published: false},
      %{title: "post 4", body: "this is post 4.", published: false}
    ]
  end
end
