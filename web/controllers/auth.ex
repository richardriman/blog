defmodule PhoenixBlog.Auth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _) do
    admin = Application.get_env(:phoenix_blog, :admin)
    IO.puts(admin)
    case conn.assigns.current_user do
      %{:email => ^admin} ->
        IO.puts("Access granted!")
        conn
      _ ->
        IO.puts("No access!")
        conn |> Phoenix.Controller.redirect(to: "/posts") |> halt
    end
  end
end