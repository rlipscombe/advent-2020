defmodule Day15ex do
  def main(_args) do
    # numbers = [0, 3, 6]
    numbers = [1, 20, 11, 6, 12, 0]
    # turns = 10
    # turns = 2020
    turns = 30_000_000

    map =
      numbers
      |> Enum.with_index(1)
      |> Enum.reduce(Map.new(), fn {number, turn}, map ->
        IO.puts("Turn #{turn}: #{number}")
        Map.put(map, number, [turn])
      end)

    last = List.last(numbers)
    turn = length(numbers) + 1
    next_turn(turn, turns, last, map)
  end

  defp next_turn(turn, turns, last, map) when turn <= turns do
    # IO.puts("Turn #{turn}: last number was #{last}")

    next =
      case Map.get(map, last) do
        [t] when t == turn - 1 ->
          # IO.puts("not seen before")
          0

        [t] ->
          # IO.puts("last seen #{t}")
          turn - 1 - t

        [a, b | _] ->
          # IO.puts("last seen #{a} and #{b}")
          a - b
      end

    # case rem(turn, 10_000) do
    #   0 -> IO.puts("Turn #{turn}: #{next}")
    #   _ -> nil
    # end

    map =
      Map.update(map, next, [turn], fn
        [t | _] -> [turn, t]
      end)

    next_turn(turn + 1, turns, next, map)
  end

  defp next_turn(_, turn, last, _), do: IO.puts("Turn #{turn}: #{last}")
end
