defmodule BlogWeb.UserView do
  use BlogWeb, :view
  @behaviour BlogWeb.CustomPageTitle

  def title("new.html", _assigns), do: "Register"
end
