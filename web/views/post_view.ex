defmodule PhoenixBlog.PostView do
  use PhoenixBlog.Web, :view

  def get_preview(post, count \\ 50) do
    String.split(post.body, " ")
    |> Enum.take(count)
    |> Enum.join(" ")
    |> Kernel.<> "..."
  end

  def get_formatted_date(post) do
    Integer.to_string(post.inserted_at.month)
    |> Kernel.<> "/"
    |> Kernel.<> Integer.to_string(post.inserted_at.day)
    |> Kernel.<> "/"
    |> Kernel.<> Integer.to_string(post.inserted_at.year)
  end
end
