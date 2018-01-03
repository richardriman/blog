defmodule BlogWeb.PostController do
  @moduledoc """
  Provides controller actions for working with blog posts.
  """

  use BlogWeb, :controller
  alias Blog.Post

  # Make sure the user is logged in when attempting to access restricted routes.
  plug :authenticate_user when action in [:new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    posts = ControllerHelpers.list_authorized_posts(conn)
    
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get_by!(Post, slug: id)

    if post.published == true || conn.assigns.current_user do
      render(conn, "show.html", post: post)
    else
      conn
      |> put_flash(:error, "This post cannot be viewed.")
      |> redirect(to: post_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get_by!(Post, slug: id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get_by!(Post, slug: id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get_by!(Post, slug: id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
