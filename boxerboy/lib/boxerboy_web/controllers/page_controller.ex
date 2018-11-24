defmodule BoxerboyWeb.PageController do
  use BoxerboyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def terrain(conn, params) do
    params["name"]
    |> Pixeldb.fetch(:terrain)
    |> (fn pixel ->
          render(conn, "terrain.html", pixel: pixel)
        end).()
  end
end
