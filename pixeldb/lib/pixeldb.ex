defmodule Pixeldb do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # worker(One.Worker, [arg1, arg2, arg3]),
    ]

    opts = [
      strategy: :one_for_one,
      name: Pixeldb.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
