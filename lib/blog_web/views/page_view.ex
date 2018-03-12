defmodule BlogWeb.PageView do
  use BlogWeb, :view

  def modify_post_title(post) do
    if post.published, do: post, else: Map.put(post, :title, post.title <> " (unpublished)")
  end

  def title("index.html", _assigns), do: "Home"
end
