defmodule BlogWeb.Router do
  use BlogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BlogWeb.Auth
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", BlogWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, only: [:create, :delete]
    resources "/posts", PostController

    get "/login", SessionController, :new
    get "/register", UserController, :new

    get "/resume", PageController, :resume
  end

  # Other scopes may use custom stacks.
  # scope "/api", Blog do
  #   pipe_through :api
  # end
end
