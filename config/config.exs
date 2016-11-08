# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_blog,
  ecto_repos: [PhoenixBlog.Repo],
  admin: "sweeneyjohnjoseph@gmail.com"

# Configures the endpoint
config :phoenix_blog, PhoenixBlog.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GUw19tnXExwbl6s3JsKsxU1hKaP1wJcq3X/S+Sh3URvH4OKm4qP03vtxCDx9ystn",
  render_errors: [view: PhoenixBlog.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixBlog.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :addict,
  secret_key: "243262243132244d37586c766b69324f654b58395a73345342464f672e",
  extra_validation: fn ({valid, errors}, user_params) -> {valid, errors} end, # define extra validation here
  user_schema: PhoenixBlog.User,
  repo: PhoenixBlog.Repo,
  from_email: "no-reply@example.com", # CHANGE THIS
mail_service: nil
  