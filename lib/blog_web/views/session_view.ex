defmodule BlogWeb.SessionView do
  use BlogWeb, :view
  @behaviour BlogWeb.CustomPageTitle

  def title("new.html", _assigns), do: "Login"
end
