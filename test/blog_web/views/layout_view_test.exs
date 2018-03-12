defmodule BlogWeb.LayoutViewTest do
  use BlogWeb.ConnCase, async: true
  import BlogWeb.LayoutView

  @default_title "Joe Sweeney"

  defmodule ViewModuleWithoutFunction do
    def foo(), do: :bar
  end

  defmodule ViewModuleWithoutClause do
    def title("index.html", _assigns), do: "Page"
  end

  describe "title/3" do
    test "returns title from view module title/2" do
      assert title(ViewModuleWithoutClause, "index.html", %{}) == "Page | Joe Sweeney"
    end

    test "returns default title when view module doesn't implement title/2" do
      assert title(ViewModuleWithoutFunction, "show.html", %{}) == @default_title
    end

    test "returns default title when view module doesn't implement correct title/2 clause" do
      assert title(ViewModuleWithoutClause, "show.html", %{}) == @default_title
    end
  end
end
