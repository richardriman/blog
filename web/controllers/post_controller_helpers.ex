defmodule Blog.PostControllerHelpers do
  import Ecto.Query
  alias Blog.Repo
  alias Blog.Post

  def get_post_list(conn) do
    query = 
      if conn.assigns.current_user do
        from p in Post,
        order_by: [desc: p.inserted_at],
        select: p
      else
        from p in Post,
        where: p.published == true,
        order_by: [desc: p.inserted_at],
        select: p
      end
    Repo.all(query)
  end
end