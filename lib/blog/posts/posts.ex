defmodule Blog.Posts do
  @moduledoc """
  This is the context which handles all post functionality.
  """

  import Ecto
  import Ecto.Query, warn: false
  alias Blog.Repo
  alias Blog.Post

  @doc """
  Gets a list of all published posts.
  """
  def list_published_posts() do
    query =  
        from p in Post,
        where: p.published == true,
        order_by: [desc: p.inserted_at],
        select: p
    Repo.all(query)
  end

  @doc """
  Gets a list of all posts, published and unpublished.
  """
  def list_posts() do
    query = 
        from p in Post,
        order_by: [desc: p.inserted_at],
        select: p

    Repo.all(query)
  end
end
