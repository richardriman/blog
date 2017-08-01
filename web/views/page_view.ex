defmodule Blog.PageView do
  use Blog.Web, :view

  def modify_post_title(post) do
    if post.published, do: post, else: Map.put(post, :title, post.title <> " (unpublished)")
  end
end
