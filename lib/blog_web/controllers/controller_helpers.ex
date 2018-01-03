defmodule BlogWeb.ControllerHelpers do
  @moduledoc """
  Provides miscellaneous post functions used by multiple modules.
  """

  alias BlogWeb.Auth  

  @doc """
  Returns a list of blog posts.

  If the user is logged in, unpublished posts are included. Otherwise, only published posts are included.
  """
  def list_authorized_posts(conn) do
    if Auth.logged_in?(conn) do
      Blog.Posts.list_posts()
    else
      Blog.Posts.list_published_posts()
    end
  end
end
