defmodule PhoenixBlog.PostView do
  use PhoenixBlog.Web, :view
  import PhoenixBlog.PostHelpers

  def get_formatted_post(post) do
    post.body
    |> Earmark.as_html!()
    |> String.replace("<table>", "<table class=\"pure-table\">")
  end
end