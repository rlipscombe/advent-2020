defmodule Day1 do
  def main(_args) do
    input = File.read!("input") |> String.split |> Enum.map(&String.to_integer/1)
    arity = 3
    goal = 2020
    [vals] = Combination.combine(input, arity) |> Enum.filter(fn vals -> Enum.sum(vals) == goal end)
    IO.puts(Enum.reduce(vals, fn x, y -> x * y end))
  end
end
