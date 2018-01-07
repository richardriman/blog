defmodule BlogWeb.PostController do
  @moduledoc """
  Provides controller actions for working with blog posts.
  """

  use BlogWeb, :controller
  alias BlogWeb.Router.Helpers
  alias Blog.Post
  alias Blog.Posts

  # Make sure the user is logged in when attempting to access restricted routes.
  plug :authenticate_user when action in [:new, :create, :edit, :update, :delete]

  defp authenticate_user(conn, _opts) do
    if Auth.logged_in?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    posts = ControllerHelpers.list_authorized_posts(conn)
    
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Posts.create_post(post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post_by_slug!(id) 

    if post.published == true || Auth.logged_in?(conn) do
      render(conn, "show.html", post: post)
    else
      conn
      |> put_flash(:error, "This post cannot be viewed.")
      |> redirect(to: post_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post_by_slug!(id) 
    changeset = Posts.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post_by_slug!(id) 

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post_by_slug!(id) 

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
