defmodule Day5ex do
  def main(_args) do
    seats =
      File.read!("input")
      |> String.split("\n", trim: true)
      |> Enum.map(&convert/1)

    _part1 =
      seats
      |> Enum.max()
      |> IO.inspect()

    # Note: throw as non-local return
    _part2 =
      try do
        seats
        |> Enum.sort()
        |> Enum.reduce(fn
          x, acc when x == acc + 1 -> x
          _x, acc -> throw(acc + 1)
        end)
      catch
        x -> x
      end
      |> IO.inspect()

    # Alternatively: do it by explicitly generating the pairs
    [{part2, _} | _] =
      seats |> Enum.sort() |> pairs() |> Enum.drop_while(fn {x, y} -> x + 1 == y end)

    (part2 + 1) |> IO.inspect()
  end

  defp pairs(enumerable) do
    next_pairs(enumerable, []) |> Enum.reverse()
  end

  defp next_pairs([a, b | rest] = _enumerable, init) do
    next_pairs([b | rest], [{a, b} | init])
  end

  defp next_pairs(_enumerable, init), do: init

  defp convert(s), do: convert(s, 0)
  defp convert("B" <> rest, acc), do: convert(rest, acc * 2 + 1)
  defp convert("F" <> rest, acc), do: convert(rest, acc * 2)
  defp convert("R" <> rest, acc), do: convert(rest, acc * 2 + 1)
  defp convert("L" <> rest, acc), do: convert(rest, acc * 2)
  defp convert("", acc), do: acc
end
