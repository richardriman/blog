defmodule PhoenixBlog.User do
  use PhoenixBlog.Web, :model

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :encrypted_password, :name])
    |> validate_required([:email, :encrypted_password, :name])
  end
end
