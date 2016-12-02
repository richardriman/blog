defmodule PhoenixBlog.PostHelpers do
  def get_formatted_date(post) do
    Integer.to_string(post.inserted_at.month)
    |> Kernel.<>("/")
    |> Kernel.<>(Integer.to_string(post.inserted_at.day))
    |> Kernel.<>("/")
    |> Kernel.<>(Integer.to_string(post.inserted_at.year))
  end
end