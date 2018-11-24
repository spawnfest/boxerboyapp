defmodule Pixeldb.Mixfile do
  use Mix.Project

  @name :pixeldb
  @version "0.1.0"

  @deps [
    {:persistent_ets, github: "michalmuskala/persistent_ets"},
    {:fn_expr, "~> 0.3"},
    {:ex_doc, ">= 0.0.0", only: :dev}
  ]

  @aliases []

  @package [
    name: @name,
    files: ["lib", "mix.exs", "README*", "LICENSE*"],
    maintainers: ["Andrew Forward"],
    licenses: ["MIT"]
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env() == :prod

    [
      app: @name,
      version: @version,
      elixir: ">= 1.7.1",
      description: "A database for storing 'pixel' drawings",
      docs: [main: "Pixeldb", extras: ["README.md"]],
      package: @package,
      build_embedded: in_production,
      deps: @deps,
      aliases: @aliases,
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
