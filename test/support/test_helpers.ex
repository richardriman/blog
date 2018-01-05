defmodule Blog.TestHelpers do
  alias Blog.Repo

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
        name: "Test User",
        username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
        password: "secret"
      }, attrs)

    %Blog.User{}
    |> Blog.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_post(attrs \\ %{}) do
    %Blog.Post{}
    |> Blog.Post.changeset(attrs)
    |> Repo.insert!()
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
