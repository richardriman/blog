defmodule BlogWeb.PageControllerTest do
  use BlogWeb.ConnCase
  import Blog.PostsFixtures

  describe "GET /" do
    test "shows home page", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "John Joseph Sweeney"
    end

    test "handles no post for latest post", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "None yet!"
    end

    test "only shows latest published post", %{conn: conn} do
      posts = varied_published_post_attrs()

      for post <- posts do
        post = post_fixture(post)
        conn = get(conn, "/")
        if post.published do
          assert html_response(conn, 200) =~ post.title
        else
          refute html_response(conn, 200) =~ post.title
        end
      end
    end

    test "shows latest post for logged in user", %{conn: conn} do
      conn = login_as(conn, "user")
      posts = varied_published_post_attrs()

      for post <- posts do
        post = post_fixture(post)
        conn = get(conn, "/")
        if post.published do
          assert html_response(conn, 200) =~ post.title
        else
          assert html_response(conn, 200) =~ post.title <> " (unpublished)"
        end
      end
    end
  end

  test "GET /resume redirects to resume_url in application env", %{conn: conn} do
    app = :blog
    url = Application.get_env(app, :resume_url)
    conn = get(conn, "/resume")
    assert redirected_to(conn, 302) =~ url 
  end
end
