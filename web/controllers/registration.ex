defmodule PhoenixBlog.Registration do
  import Plug.Conn
  import Phoenix.Controller
  alias PhoenixBlog.Router.Helpers

  def init(opts), do: opts

  def call(conn, _opts) do
    if (Application.get_env(:phoenix_blog, :user_registration) != :enabled) do
      conn
      |> put_flash(:error, "Registration is disabled!")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    else 
      conn
    end
  end
end