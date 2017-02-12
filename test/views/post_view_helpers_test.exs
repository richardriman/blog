defmodule PhoenixBlog.PostHelpersTest do
  use ExUnit.Case, async: true
  import PhoenixBlog.PostViewHelpers

  test "get_formatted_date returns correctly formatted date" do
    posts = [
      %{inserted_at: ~D[2012-07-08], formatted_date: "8 Jul 2012"},
      %{inserted_at: ~D[2015-11-10], formatted_date: "10 Nov 2015"},
      %{inserted_at: ~D[2017-01-25], formatted_date: "25 Jan 2017"}
    ]

    for post <- posts do
      assert get_formatted_date(post) == post.formatted_date
    end
  end
end