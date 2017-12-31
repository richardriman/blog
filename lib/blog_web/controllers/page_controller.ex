defmodule BlogWeb.PageController do
  @moduledoc """
  Provides controller actions for static pages.
  """
  use BlogWeb, :controller

  def index(conn, _params) do
    latest_post =
      conn
      |> get_post_list()
      |> List.first

    render(conn, "index.html", latest_post: latest_post)
  end

  def resume(conn, _params) do
    redirect(conn, external: "https://docs.google.com/document/d/19oHVdNPB6kei_OaQSQ1afYZCcQFh_oBw91yiNG2mLHQ/export?format=pdf")
  end
end
