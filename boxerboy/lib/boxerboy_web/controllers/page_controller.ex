defmodule BoxerboyWeb.PageController do
  use BoxerboyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def build(conn, _params) do
    render(conn, "build.html", terrains: Pixeldb.ls_la(:terrains))
  end

  def terrain(conn, params) do
    params["name"]
    |> Pixeldb.fetch(:terrains)
    |> (fn pixel ->
          render(conn, "terrain.html", pixel: pixel)
        end).()
  end
end
