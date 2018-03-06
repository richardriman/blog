defmodule BlogWeb.PageViewTest do
  use BlogWeb.ConnCase, async: true
  import Phoenix.View
  import Blog.PostsFixtures
  import BlogWeb.PageView

  describe "index.html" do
    test "renders index.html", %{conn: conn} do
      post = post_fixture()
      content = render_to_string(BlogWeb.PageView, "index.html", conn: conn, latest_post: post)
      assert String.contains?(content, "John Joseph Sweeney")
      assert String.contains?(content, post.title)
    end

    test "renders index.html with unpublished posts", %{conn: conn} do
      post = post_fixture(%{published: false})
      content = render_to_string(BlogWeb.PageView, "index.html", conn: conn, latest_post: post)
      assert String.contains?(content, "John Joseph Sweeney")
      assert String.contains?(content, post.title)
      assert String.contains?(content, "#{post.title} (unpublished)")
    end
  end

  test "modify_post_title/1 adds unpublished status" do
    post = post_fixture()
    assert modify_post_title(post).title == post.title
    assert modify_post_title(Map.merge(post, %{published: false})).title == post.title <> " (unpublished)"
  end
end
