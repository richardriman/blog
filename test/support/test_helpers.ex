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
end