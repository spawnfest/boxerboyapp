defmodule Pixeldb.Mixfile do
  use Mix.Project

  @name :pixeldb
  @version "0.1.0"

  @deps [
    # { :earmark, ">0.1.5" },
    # { :ex_doc,  "1.2.3", only: [ :dev, :test ] },
    # { :my_app:  path: "../my_app" },
  ]

  @aliases []

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env() == :prod

    [
      app: @name,
      version: @version,
      elixir: ">= 1.7.1",
      deps: @deps,
      aliases: @aliases,
      elixirc_paths: ["lib"],
      build_embedded: in_production
    ]
  end

  def application do
    [
      mod: {Pixeldb, []},
      extra_applications: [
        :logger
      ]
    ]
  end
end
