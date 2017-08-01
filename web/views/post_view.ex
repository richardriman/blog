defmodule Blog.PostView do
  use Blog.Web, :view

  def get_formatted_post(post) do
    post.body
    |> Earmark.as_html!()
    |> String.replace("<table>", "<table class=\"pure-table\">")
  end
end