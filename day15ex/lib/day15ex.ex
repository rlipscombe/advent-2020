defmodule Day15ex do
  def main(_args) do
    numbers = [0, 3, 6]
    turns = 2020 #10

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
    #IO.puts("Turn #{turn}: last number was #{last}")

    next = case Map.get(map, last) do
      [t] when t == turn - 1 ->
        #IO.puts("not seen before")
        0
      [t] ->
        #IO.puts("last seen #{t}")
        (turn - 1) - t
      [a, b | _] ->
        #IO.puts("last seen #{a} and #{b}")
        a - b
    end

    IO.puts("Turn #{turn}: #{next}")

    map = Map.update(map, next, [turn], fn ts -> [turn | ts] end)
    next_turn(turn + 1, turns, next, map)
  end

  defp next_turn(_, _, _, _), do: nil
end
