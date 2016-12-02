defmodule PhoenixBlog.PageController do
  use PhoenixBlog.Web, :controller

  alias PhoenixBlog.Post

  def index(conn, _params) do
    query = from p in Post,
      order_by: [desc: p.inserted_at],
      select: p

    latest_post = query 
      |> Repo.all
      |> List.first

    render(conn, "index.html", latest_post: latest_post)
  end
end
