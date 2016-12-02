defmodule PhoenixBlog.PostView do
  use PhoenixBlog.Web, :view

  import PhoenixBlog.PostHelpers

  alias PhoenixBlog.Post

  # def get_latest_post_id(posts) do
  #   %Post{:id => id} = List.first(posts)
  #   id
  # end
end