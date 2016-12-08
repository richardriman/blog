defmodule PhoenixBlog.Post do
  use PhoenixBlog.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    field :published, :boolean

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :published])
    |> validate_required([:title, :body, :published])
  end
end
