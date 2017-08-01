defmodule Blog.UserController do
  use Blog.Web, :controller
  alias Blog.User
  alias Blog.Router.Helpers
  alias Blog.Repo

  plug :check_user_registration when action in [:new, :create]

  def check_user_registration(conn, _opts) do
    case Repo.all(User) do
      [] -> conn
      _ -> 
        conn
        |> put_flash(:error, "Registration is disabled!")
        |> redirect(to: Helpers.page_path(conn, :index))
        |> halt()
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
        |> Blog.Auth.login(user)
        |> put_flash(:info, "#{user.name} successfully registered!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end