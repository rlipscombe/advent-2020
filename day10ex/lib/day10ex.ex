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

    # paths = part2(values, [0])
    # IO.puts("part 2 = #{length(paths)}")

    # Forget actually working out the paths (because that takes a lot of memory).
    # Let's try something different: merely counting all the ways I can get to a particular node.
    map = part2bis([0 | values], %{0 => 1})
    part2 = Map.get(map, max)
    IO.puts("part 2 = #{part2}")
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

  defp part2bis([], map), do: map
  defp part2bis([v | values], map) do
    vs = values |> Enum.filter(fn x -> x <= v + 3 end)
    #IO.puts("#{inspect(vs)}")

    c = Map.get(map, v)
    #IO.puts("#{v} #{c}")
    map = Enum.reduce(vs, map, fn w, map ->
      #IO.puts("#{v}(#{c}) -> #{w}")
      Map.update(map, w, c, fn x -> x + c end)
    end)

    part2bis(values, map)
  end

  # Look at it backwards: At any point, I've got a breadcrumb trail of how I got
  # here, plus a bunch of options for my next step.
  defp part2(values, [p | _] = path) do
    # Need to explore all of the possible paths from here. That is:
    # for each valid next item in 'values', recurse.
    options = values |> Enum.filter(fn x -> x > p && x <= p + 3 end)

    case options do
      [] ->
        [path]

      _ ->
        Enum.flat_map(options, fn v ->
          part2(values -- [v], [v | path])
        end)
    end
  end
end
