defmodule PhoenixBlog.UserController do
  use PhoenixBlog.Web, :controller
  alias PhoenixBlog.User
  alias PhoenixBlog.Router.Helpers

  plug :check_user_registration when action in [:new, :create]

  def check_user_registration(conn, _opts) do
    if (Application.get_env(:phoenix_blog, :user_registration) != :enabled) do
      conn
      |> put_flash(:error, "Registration is disabled!")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    else 
      conn
    end
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> PhoenixBlog.Auth.login(user)
        |> put_flash(:info, "#{user.name} successfully registered!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end