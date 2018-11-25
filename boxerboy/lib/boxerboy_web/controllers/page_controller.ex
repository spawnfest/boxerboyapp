defmodule BoxerboyWeb.PageController do
  use BoxerboyWeb, :controller

  def index(conn, _params) do
    characters = Pixeldb.ls_la(:characters)

    render(
      conn,
      "index.html",
      terrains: Pixeldb.ls_la(:terrains),
      maps: Pixeldb.ls_la(:maps),
      characters: characters,
      featured_character: Enum.random(characters)
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

  def character(conn, params) do
    params["name"]
    |> Pixeldb.fetch(:characters)
    |> (fn pixel ->
          render(conn, "character.html", pixel: pixel)
        end).()
  end

  def terrain_bitmap(conn, params), do: :terrains |> gen_bitmap(conn, params)
  def character_bitmap(conn, params), do: :characters |> gen_bitmap(conn, params)

  def gen_bitmap(pixeldb, conn, params) do
    params["name"]
    |> Pixeldb.fetch(pixeldb)
    |> Pixeldb.to_bmp()
    |> case do
      bmp -> conn |> put_resp_content_type("image/bmp") |> send_resp(200, bmp)
    end
  end
end
