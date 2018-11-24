defmodule Boxerboy.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BoxerboyWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Boxerboy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BoxerboyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
