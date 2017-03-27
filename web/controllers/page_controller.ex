defmodule Arrivals.PageController do
  use Arrivals.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
