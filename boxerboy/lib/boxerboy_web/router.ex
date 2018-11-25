defmodule BoxerboyWeb.Router do
  use BoxerboyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BoxerboyWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/build", PageController, :build
    get "/build/terrain", PageController, :terrain
    get "/build/terrain/:name", PageController, :terrain
    get "/build/map", PageController, :map
    get "/build/map/:name", PageController, :map

    get "/gen/terrain/:name", PageController, :terrain_bitmap
  end

  scope "/api", BoxerboyWeb do
    pipe_through(:api)
    put("/build/terrain", ApiController, :upsert_terrain)
    put("/build/map", ApiController, :upsert_map)
  end
end
