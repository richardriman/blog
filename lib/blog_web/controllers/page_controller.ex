defmodule BlogWeb.PageController do
  @moduledoc """
  Provides controller actions for static pages.
  """
  use BlogWeb, :controller

  def index(conn, _params) do
    latest_post =
      conn
      |> ControllerHelpers.list_authorized_posts()
      |> List.first()
    
    render(conn, "index.html", latest_post: latest_post)
  end

  def resume(conn, _params) do
    app = Application.get_application(__MODULE__)
    url = Application.get_env(app, :resume_url)
    redirect(conn, external: url)
  end
end
