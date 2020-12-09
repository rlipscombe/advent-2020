defmodule Day9ex do
  def main([path, len]) do
    len = String.to_integer(len)

    values = File.read!(path) |> String.split() |> Enum.map(&String.to_integer/1)

    # Part 1
    chunks = values |> Enum.chunk_every(len + 1, 1)

    part1 =
      Enum.reduce_while(chunks, nil, fn chunk, acc ->
        {prelude, [this]} = Enum.split(chunk, len)

        # Are there any 2-tuples in the prelude that sum to this?
        case Combination.combine(prelude, 2) |> Enum.any?(fn [a, b] -> a + b == this end) do
          false -> {:halt, this}
          _ -> {:cont, acc}
        end
      end)

    IO.puts("part1 = #{part1}")

    # Part 2
    set = Enum.reduce_while(2..length(values), nil, fn len, _ ->
      chunks = Enum.chunk_every(values, len, 1)

      res =
        chunks
        |> Enum.reduce_while(nil, fn chunk, _ ->
          case Enum.sum(chunk) == part1 do
            true -> {:halt, chunk}
            _ -> {:cont, nil}
          end
        end)

      case res do
        nil -> {:cont, nil}
        _ -> {:halt, res}
      end
    end)

    part2 = Enum.min(set) + Enum.max(set)
    IO.puts("part2 = #{part2}")
  end
end
