defmodule PhoenixBlog.PostController do
  use PhoenixBlog.Web, :controller

  alias PhoenixBlog.Post

  plug :authenticate_user when action in [:new, :edit]

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

    posts = query |> Repo.all
    
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

  # def show(conn, %{"id" => id}) do
  #   post = Repo.get!(Post, id)

  #   if (post.published == true || conn.assigns.current_user) do
  #     render(conn, "show.html", post: post)
  #   else
  #     conn
  #     |> put_flash(:error, "This post cannot be viewed.")
  #     |> redirect(to: post_path(conn, :index))
  #   end
  # end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    if (post.published == true || conn.assigns.current_user) do
      render(conn, "show.html", post: post)
    else
      conn
      |> put_flash(:error, "This post cannot be viewed.")
      |> redirect(to: post_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
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
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
