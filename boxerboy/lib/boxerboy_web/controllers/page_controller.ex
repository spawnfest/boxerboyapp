defmodule BoxerboyWeb.PageController do
  use BoxerboyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
