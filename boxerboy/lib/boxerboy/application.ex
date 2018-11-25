defmodule Boxerboy.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BoxerboyWeb.Endpoint,
      Supervisor.child_spec({Pixeldb.Worker, [table: "terrains.tab", name: :terrains]},
        id: :terrains
      ),
      Supervisor.child_spec({Pixeldb.Worker, [table: "maps.tab", name: :maps]}, id: :maps),
      Supervisor.child_spec({Pixeldb.Worker, [table: "characters.tab", name: :characters]},
        id: :characters
      )
    ]

    opts = [strategy: :one_for_one, name: Boxerboy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BoxerboyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
