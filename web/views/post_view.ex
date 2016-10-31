defmodule PhoenixBlog.PostView do
  use PhoenixBlog.Web, :view

  def get_preview(post, count \\ 50) do
    String.split(post.body, " ")
    |> Enum.take(count)
    |> Enum.join(" ")
    |> Kernel.<> "..."
  end
end
