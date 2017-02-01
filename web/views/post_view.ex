defmodule PhoenixBlog.PostView do
  use PhoenixBlog.Web, :view
  import PhoenixBlog.PostHelpers

  def translate_slug_error(changeset) do
    if changeset.errors[:slug] do
      new_error = {"There was a problem generating a unique slug for this post. Please ensure that this title is not already taken.", []}
      Map.update!(changeset, :errors, 
        fn errors -> Keyword.update!(errors, :slug, fn _ -> new_error end) 
      end)
    else
      changeset
    end
  end
end