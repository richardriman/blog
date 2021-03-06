defmodule Blog.Posts.Post do
  use BlogWeb, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    field :published, :boolean
    field :slug, :string

    timestamps()
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, Slugger.slugify_downcase(title))
    else
      changeset
    end  
  end

  @doc false 
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :published])
    |> validate_required([:title, :body, :published])
    |> slugify_title()
    |> unique_constraint(:slug, message: "There was a problem generating a unique slug for this post. Please ensure that this title is not already taken.")
  end

  defimpl Phoenix.Param, for: Blog.Posts.Post do
    def to_param(%{slug: slug}), do: slug
  end
end
