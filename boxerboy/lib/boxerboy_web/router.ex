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
    get "/terrain", PageController, :terrain
    get "/terrain/:name", PageController, :terrain
    get "/map", PageController, :map
    get "/map/:name", PageController, :map
    get "/character", PageController, :character
    get "/character/:name", PageController, :character

    get "/gen/terrain/:name", PageController, :terrain_bitmap
    get "/gen/character/:name", PageController, :character_bitmap
  end

  scope "/api", BoxerboyWeb do
    pipe_through(:api)
    put("/terrain", ApiController, :upsert_terrain)
    put("/map", ApiController, :upsert_map)
    put("/character", ApiController, :upsert_character)
  end
end
