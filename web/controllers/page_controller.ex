defmodule PhoenixBlog.PageController do
  use PhoenixBlog.Web, :controller

  alias PhoenixBlog.Post

  def index(conn, _params) do
    query = 
      if (conn.assigns.current_user) do
        from p in Post,
        order_by: [desc: p.inserted_at],
        select: p
      else
        from p in Post,
        where: p.published == true,
        order_by: [desc: p.inserted_at],
        select: p
      end
    
    latest_post = query 
      |> Repo.all
      |> List.first

    render(conn, "index.html", latest_post: latest_post)
  end

  def resume(conn, _params) do
    redirect(conn, external: "https://docs.google.com/document/d/19oHVdNPB6kei_OaQSQ1afYZCcQFh_oBw91yiNG2mLHQ/export?format=pdf")
  end
end
