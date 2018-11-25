defmodule BoxerboyWeb.ApiController do
  use BoxerboyWeb, :controller

  def upsert_terrain(conn, params), do: :terrains |> upsert(conn, params)
  def upsert_map(conn, params), do: :maps |> upsert(conn, params)
  def upsert_character(conn, params), do: :characters |> upsert(conn, params)

  def delete_terrain(conn, params), do: :terrains |> delete(conn, params)
  def delete_map(conn, params), do: :maps |> delete(conn, params)
  def delete_character(conn, params), do: :characters |> delete(conn, params)

  def upsert(db, conn, params) do
    params
    |> Pixeldb.upsert(db)
    |> case do
      {:ok, pixel} ->
        render(conn, "data.json", data: [true, pixel])

      {:error, msg} ->
        render(conn, "data.json", data: [false, msg])
    end
  end

  def delete(db, conn, params) do
    params["name"]
    |> Pixeldb.delete(db)
    |> case do
      pixel -> render(conn, "data.json", data: [true, pixel])
    end
  end
end
