defmodule BlogWeb.UserView do
  use BlogWeb, :view

  def title("new.html", _assigns), do: "Register"
end
