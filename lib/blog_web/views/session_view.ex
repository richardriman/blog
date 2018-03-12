defmodule BlogWeb.SessionView do
  use BlogWeb, :view

  def title("new.html", _assigns), do: "Login"
end
