defmodule BoxerboyWeb.ApiController do
  use BoxerboyWeb, :controller

  def upsert_terrain(conn, params) do
    params
    |> Pixeldb.upsert(:terrains)
    |> case do
      {:ok, pixel} ->
        render(conn, "data.json", data: [true, pixel])

      {:error, msg} ->
        render(conn, "data.json", data: [false, msg])
    end
  end
end
