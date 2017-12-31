defmodule BlogWeb.PostControllerHelpers do
  @moduledoc """
  Provides miscellaneous post functions used by multiple modules.
  """
  
  import Ecto.Query
  alias Blog.Repo
  alias Blog.Post

  @doc """
  Returns a list of blog posts.

  If the user is logged in, unpublished posts are included. Otherwise, only published posts are included.
  """
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
