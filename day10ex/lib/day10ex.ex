defmodule Day10ex do
  def main([path]) do
    values = File.read!(path) |> String.split() |> Enum.map(&String.to_integer/1)

    {ones, threes} =
      values
      |> Enum.sort()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce({1, 1}, fn [a, b], {ones, threes} ->
        case b - a do
          1 -> {ones + 1, threes}
          3 -> {ones, threes + 1}
        end
      end)

    product = ones * threes
    IO.puts("part 1 = #{product}")
  end
end
