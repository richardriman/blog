defmodule BlogWeb.LayoutViewTest do
  use BlogWeb.ConnCase, async: true
  import BlogWeb.LayoutView

  @default_title "Joe Sweeney"

  defmodule ViewModuleWithoutBehaviour do
    def foo(), do: :bar
  end

  defmodule ViewModuleWithBehaviour do
    @behaviour BlogWeb.CustomPageTitle
    def title("index.html", _assigns), do: "Page"
  end

  defmodule ViewModuleWithBehaviourWithoutClause do
    @behaviour BlogWeb.CustomPageTitle
    def title("show.html", _assigns), do: "Page"
  end

  defmodule ViewModuleWithBehaviourAliased do
    alias BlogWeb.CustomPageTitle
    @behaviour CustomPageTitle
    def title("index.html", _assigns), do: "Page"
  end

  describe "title/3" do
    test "returns title from view module implementing behaviour" do
      assert title(ViewModuleWithBehaviour, "index.html", %{}) == "Page | Joe Sweeney"
    end

    test "returns title from view module implementing behaviour missing clause" do
      assert title(ViewModuleWithBehaviourWithoutClause, "index.html", %{}) == @default_title
    end

    test "returns title from view module implementing aliased behaviour" do
      assert title(ViewModuleWithBehaviourAliased, "index.html", %{}) == "Page | Joe Sweeney"
    end

    test "returns default title from view module not implemeting behaviour" do
      assert title(ViewModuleWithoutBehaviour, "index.html", %{}) == @default_title
    end
  end
end
