defmodule Day10ex do
  def main([path]) do
    values =
      File.read!(path)
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()

    IO.puts("part 1 = #{part1(values)}")

    # Are there any duplicates in the input? What are the min and max values?
    len = length(values)
    uniq_len = values |> Enum.uniq() |> length()
    min = values |> Enum.min()
    max = values |> Enum.max()
    IO.puts("len #{len}, uniq_len #{uniq_len}, min #{min}, max #{max}")
    # Answer: no duplicates, 92 entries, min 1, max 138

    # Forget actually working out the paths (because that takes a lot of memory).
    # Let's try something different: merely counting all the ways I can get to a particular node.
    IO.puts("part 2 = #{part2(values)}")
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

  defp part2(values), do: part2([0 | values], %{0 => 1})

  defp part2([last], map), do: Map.get(map, last)

  defp part2([here | rest], map) do
    # How many ways are there to get *to* here?
    count = Map.get(map, here)

    # Where can we go *from* here?
    theres = rest |> Enum.filter(fn there -> there <= here + 3 end)

    # Add the number of ways to get *here* to the number of ways to get *there*.
    map =
      Enum.reduce(theres, map, fn there, map ->
        Map.update(map, there, count, fn x -> x + count end)
      end)

    # Next.
    part2(rest, map)
  end
end
