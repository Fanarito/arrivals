defmodule Arrivals.Router do
  use Arrivals.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/", Arrivals do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/flights", FlightController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Arrivals do
    pipe_through :api

    resources "/flights", FlightController, only: [:index, :show]
    resources "/airlines", AirlineController, only: [:index]
  end
end
