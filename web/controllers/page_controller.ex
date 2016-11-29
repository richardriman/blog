defmodule PhoenixBlog.PageController do
  use PhoenixBlog.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", logged_in: false, user: "NONE"
  end
end
