defmodule BlogWeb.UserController do
  @moduledoc """
  Provides controller actions for working with users.
  """
  
  use BlogWeb, :controller
  alias Blog.Accounts
  alias Blog.User
  alias BlogWeb.Router.Helpers

  plug :check_user_registration when action in [:new, :create]

  defp check_user_registration(conn, _opts) do
    case Accounts.list_users() do
      [] -> conn
      _ -> 
        conn
        |> put_flash(:error, "Registration is disabled!")
        |> redirect(to: Helpers.page_path(conn, :index))
        |> halt()
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> BlogWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} successfully registered!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
