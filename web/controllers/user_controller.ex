defmodule PhoenixBlog.UserController do
  use PhoenixBlog.Web, :controller
  alias PhoenixBlog.User

  def new(conn, _params) do
    if (Application.get_env(:phoenix_blog, :user_registration) != :enabled) do
      conn
      |> put_flash(:error, "Registration is disabled!")
      |> redirect(to: page_path(conn, :index))
    end
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> PhoenixBlog.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end