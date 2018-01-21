defmodule BlogWeb.Auth do
  @moduledoc """
  Plug which provides user authentication functionality.
  """

  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Blog.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        conn
      user = user_id && Accounts.get_user(user_id) -> 
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def login_by_username_and_pass(conn, username, given_pass, _opts) do
    user = Accounts.get_user_by_username(username)
    
    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logged_in?(conn) do
    if conn.assigns.current_user, do: true, else: false
  end
end
