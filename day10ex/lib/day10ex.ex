defmodule Day10ex do
  def main([path]) do
    values =
      File.read!(path)
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()

    IO.puts("part 1 = #{part1(values)}")
  end

  defp part1(values) do
    {ones, threes} =
      values
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce({1, 1}, fn [a, b], {ones, threes} ->
        case b - a do
          1 -> {ones + 1, threes}
          3 -> {ones, threes + 1}
        end
      end)

    ones * threes
  end
end
