defmodule PhoenixBlog.Post do
  use PhoenixBlog.Web, :model

  @primary_key {:id, PhoenixBlog.Permalink, autogenerate: true}
  schema "posts" do
    field :title, :string
    field :body, :string
    field :published, :boolean
    field :slug, :string

    timestamps()
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end  
  end

  defp slugify(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :published])
    |> validate_required([:title, :body, :published])
    |> slugify_title()
    |> unique_constraint(:slug)
  end

  defimpl Phoenix.Param, for: PhoenixBlog.Post do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
    end
  end
end
