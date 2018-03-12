defmodule BlogWeb.LayoutView do
  use BlogWeb, :view

  @doc """
  Returns the formatted page title using the `title/2` function of the view being rendered into the layout.
  Returns the default title if the view being rendered does not have a matching `title/2` clause or has not defined `title/2` at all.
  """
  def title(view_module, view_template, assigns) do
    default = "Joe Sweeney"
    try do
      prefix = view_module.title(view_template, assigns)
      "#{prefix} | Joe Sweeney"
    rescue
      _e in FunctionClauseError -> default
      _e in UndefinedFunctionError -> default
    end
  end
end
