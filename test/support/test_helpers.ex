defmodule PhoenixBlog.TestHelpers do
  alias PhoenixBlog.Repo

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
        name: "Test User",
        username: "user#{Base.encode16(:crypto.rand_bytes(8))}",
        password: "secret"
      }, attrs)

    %PhoenixBlog.User{}
    |> PhoenixBlog.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  # def insert_post(attrs \\ %{}), do: Repo.insert(attrs)
end