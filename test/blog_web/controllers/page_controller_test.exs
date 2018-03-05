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
      posts = [
        %{title: "post 1", body: "this is post 1.", published: true},
        %{title: "post 2", body: "this is post 2.", published: true},
        %{title: "post 3", body: "this is post 3.", published: false},
        %{title: "post 4", body: "this is post 4.", published: false}
      ]
      for post <- posts do
        post_fixture(post)
        conn = get(conn, "/")
        if post.published do
          assert html_response(conn, 200) =~ post.title
        else
          refute html_response(conn, 200) =~ post.title
        end
      end
    end

    @tag login_as: "user"
    test "shows latest post for logged in user", %{conn: conn} do
      posts = [
        %{title: "post 1", body: "this is post 1.", published: true},
        %{title: "post 2", body: "this is post 2.", published: true},
        %{title: "post 3", body: "this is post 3.", published: false},
        %{title: "post 4", body: "this is post 4.", published: false}
      ]
      for post <- posts do
        post_fixture(post)
        conn = get(conn, "/")
        if post.published do
          assert html_response(conn, 200) =~ post.title
        else
          assert html_response(conn, 200) =~ post.title <> " (unpublished)"
        end
      end
    end
  end

  test "GET /resume redirects", %{conn: conn} do
    conn = get(conn, "/resume")
    assert redirected_to(conn, 302)
  end
end
