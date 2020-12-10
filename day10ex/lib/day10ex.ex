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
    IO.puts("len #{len}, uniq_len #{uniq_len} min #{min} max #{max}")
    # Answer: no duplicates, 92 entries, min 1, max 138

    ExUnit.start()
    tests()

    IO.puts("part 2 = #{part2(values)}")
  end

  defp tests() do
    use ExUnit.Case
    assert paths([]) == []
    assert paths([1]) == [[1]]
    assert paths([1, 2]) == [[1, 2], [2]]

    assert paths([1, 2, 3, 4, 5]) == [[1, 2, 3, 4, 5], [1, 3, 4, 5], [1, 4, 5], [1, 4], [2, 3, 4, 5], [2, 4, 5], ...]
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

  defp part2(values) do
    part2(0, values, [])
  end

  # Returns a list of path suffixes from where we are to the end.
  defp part2(_, [], acc), do: acc
  defp part2(jolts, values, acc) do
    IO.inspect("(#{jolts}) #{inspect(values)} #{inspect(acc)}")
    # At each step, take one of the valid options from the front of the list.
    # We know that the list is sorted; we know that we've got a 3 jolt range; so
    # we only need to examine a limited number of options.
    prefix = Enum.take(values, 3) |> Enum.filter(fn x -> x > jolts && x <= jolts + 3 end)

    paths = for p <- prefix do
      part2(p, values -- [p], acc ++ [p])
    end |> IO.inspect

    for p <- paths do
      acc ++ p
    end
  end
end
