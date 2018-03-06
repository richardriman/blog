defmodule BlogWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Blog.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import BlogWeb.Router.Helpers
      import Blog.AccountsFixtures

      # The default endpoint for testing
      @endpoint BlogWeb.Endpoint

      @doc """
      Logs into the user specified by `username` by putting the `:current_user` assign in a new `%Plug.Conn{}`.
      """
      def login_as(conn, username) do
        user = user_fixture(%{username: username})
        conn = assign(conn, :current_user, user)
        conn 
      end

      setup %{conn: conn} = config do
        post = %Blog.Posts.Post{
            title: "test post",
            slug: "test-post", 
            body: "this is a test.", 
            published: true, 
            inserted_at: ~D[2017-01-01]
          }
        case config[:test_post] do
          true -> {:ok, conn: conn, post: post}
          opts when is_map(opts) ->
            {:ok, conn: conn, post: Map.merge(post, opts)}
          _ -> :ok
        end
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Blog.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Blog.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
