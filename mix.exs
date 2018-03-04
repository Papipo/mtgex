defmodule Mtgex.MixProject do
  use Mix.Project

  def project do
    [
      app: :mtgex,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.1.0"},
      {:poison, "~> 3.1"},
      {:flow, "~> 0.13"},
      {:exvcr, "~> 0.10.1", only: :test}
    ]
  end

  defp escript do
    [main_module: Mtgex.CLI]
  end
end
