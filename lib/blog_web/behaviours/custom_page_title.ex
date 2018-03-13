defmodule BlogWeb.CustomPageTitle do
  @callback title(view_template :: String.t(), assigns :: Plug.Conn.assigns()) :: String.t()
end
