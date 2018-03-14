defmodule BlogWeb.PostView do
  use BlogWeb, :view
  @behaviour BlogWeb.CustomPageTitle

  def get_formatted_post(post) do
    post.body
    |> Earmark.as_html!(%Earmark.Options{code_class_prefix: "lang-"})
    |> String.replace("<table>", "<table class=\"pure-table\">")
  end

  def title("edit.html", _assigns), do: "Edit Post"
  def title("index.html", _assigns), do: "Posts"
  def title("new.html", _assigns), do: "New Post"
  def title("show.html", assigns), do: assigns.post.title
end
