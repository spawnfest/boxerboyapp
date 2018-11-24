defmodule BoxerboyWeb.PageController do
  use BoxerboyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def terrain(conn, _params) do
    render(conn, "terrain.html")
  end
end
