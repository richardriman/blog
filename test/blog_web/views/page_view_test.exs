defmodule BlogWeb.PageViewTest do
  use BlogWeb.ConnCase, async: true
  import Phoenix.View
  import BlogWeb.PageView

  describe "index.html" do
    @tag :test_post
    test "renders index.html", %{conn: conn, post: post} do
      content = render_to_string(BlogWeb.PageView, "index.html", conn: conn, latest_post: post)
      assert String.contains?(content, "John Joseph Sweeney")
      assert String.contains?(content, post.title)
    end

    @tag test_post: %{published: false}
    test "renders index.html with unpublished posts", %{conn: conn, post: post} do
      content = render_to_string(BlogWeb.PageView, "index.html", conn: conn, latest_post: post)
      assert String.contains?(content, "John Joseph Sweeney")
      assert String.contains?(content, post.title)
      assert String.contains?(content, "#{post.title} (unpublished)")
    end
  end

  @tag :test_post
  test "modify_post_title/1 adds unpublished status", %{post: post} do
    assert modify_post_title(post).title == post.title
    assert modify_post_title(Map.merge(post, %{published: false})).title == post.title <> " (unpublished)"
  end
end
