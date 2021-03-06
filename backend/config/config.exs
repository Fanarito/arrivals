# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :arrivals,
  ecto_repos: [Arrivals.Repo]

# Configures the endpoint
config :arrivals, Arrivals.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "x1UoNBcK9HplAK09mYak7nIVi5cnW/54ml7XsyhGyl6dh5HRzJMO5dQgZTxpslDR",
  render_errors: [view: Arrivals.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Arrivals.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
