defmodule PhoenixBlog.PostHelpers do
  def get_formatted_date(post) do

    month_strings = %{
      1 => "Jan",
      2 => "Feb",
      3 => "Mar",
      4 => "Apr",
      5 => "May",
      6 => "Jun",
      7 => "Jul",
      8 => "Aug",
      9 => "Sep",
      10 => "Oct",
      11 => "Nov",
      12 => "Dec"
    }

    Integer.to_string(post.inserted_at.day)
    |> Kernel.<>(" ")
    |> Kernel.<>(Map.get(month_strings, post.inserted_at.month))
    |> Kernel.<>(" ")
    |> Kernel.<>(Integer.to_string(post.inserted_at.year))
  end

  def get_formatted_post(post) do
    Earmark.to_html(post.body)
    |> String.replace("<table>", "<table class=\"pure-table\">")
  end
end