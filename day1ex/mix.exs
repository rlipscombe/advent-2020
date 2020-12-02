defmodule Day1.MixProject do
  use Mix.Project

  def project do
    [
      app: :day1,
      version: "0.1.0",
      deps: deps(),
      default_task: "escript.build",
      escript: escript_options()
    ]
  end

  defp escript_options do
    [
      main_module: Day1
    ]
  end

  defp deps do
    [
    ]
  end
end
