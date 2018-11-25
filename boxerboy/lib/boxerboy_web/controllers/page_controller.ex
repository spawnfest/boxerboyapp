defmodule BoxerboyWeb.PageController do
  use BoxerboyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def build(conn, _params) do
    render(
      conn,
      "build.html",
      terrains: Pixeldb.ls_la(:terrains),
      maps: Pixeldb.ls_la(:maps)
    )
  end

  def terrain(conn, params) do
    params["name"]
    |> Pixeldb.fetch(:terrains)
    |> (fn pixel ->
          render(conn, "terrain.html", pixel: pixel)
        end).()
  end

  def map(conn, params) do
    params["name"]
    |> Pixeldb.fetch(:maps)
    |> (fn pixel ->
          render(conn, "map.html",
            pixel: pixel,
            pixels: Pixeldb.ls_la(:terrains)
          )
        end).()
  end

  def terrain_bitmap(conn, params) do
    params["name"]
    |> Pixeldb.fetch(:terrains)
    |> Pixeldb.to_bmp()
    |> case do
      bmp -> conn |> put_resp_content_type("image/bmp") |> send_resp(200, bmp)
    end
  end
end
