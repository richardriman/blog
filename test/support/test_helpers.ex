defmodule Blog.TestHelpers do
  alias Blog.Repo
  
  # TODO: move these into their own context modules and use the context functions instead of accessing the repo directly

  @valid_post_attrs %{title: "test post", body: "this is a test post.", published: true}
  def post_attrs(), do: @valid_post_attrs

  @valid_user_attrs %{name: "test user", username: "user123", password: "secret"}

  # TODO: make this look like insert_post/1 
  def insert_user(attrs \\ %{}) do
    attrs = Enum.into(attrs, @valid_user_attrs)

    {:ok, user} =
      %Blog.User{}
      |> Blog.User.registration_changeset(attrs)
      |> Repo.insert()

    user
  end
  
  def fixture_users() do
    [
      %{name: "test user 1", username: "user1", password: "secret1"},
      %{name: "test user 2", username: "user2", password: "secret2"},
      %{name: "test user 3", username: "user3", password: "secret3"},
      %{name: "test user 4", username: "user4", password: "secret4"}
    ]
  end

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
