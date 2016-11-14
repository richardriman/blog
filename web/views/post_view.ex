defmodule PhoenixBlog.PostView do
  use PhoenixBlog.Web, :view

  alias PhoenixBlog.Post

  def get_latest_post_id(posts) do
    {%Post{:id => id}, _count} = List.first(posts)
    id
  end

  def get_preview(post, count \\ 50) do
    String.split(post.body, " ")
    |> Enum.take(count)
    |> Enum.join(" ")
    |> Kernel.<>("...")
    |> Earmark.to_html()
  end

  def get_formatted_date(post) do
    Integer.to_string(post.inserted_at.month)
    |> Kernel.<>("/")
    |> Kernel.<>(Integer.to_string(post.inserted_at.day))
    |> Kernel.<>("/")
    |> Kernel.<>(Integer.to_string(post.inserted_at.year))
  end
end