defmodule PhoenixBlog.PostView do
  use PhoenixBlog.Web, :view
  import PhoenixBlog.PostHelpers

  def get_formatted_post(post) do
    Earmark.to_html(post.body)
    |> String.replace("<table>", "<table class=\"pure-table\">")
  end
end