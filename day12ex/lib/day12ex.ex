defmodule Day12ex do
  def main([path]) do
    instructions =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_instruction/1)

    # Part 1
    ship = Enum.reduce(instructions, Part1.new(), &Part1.execute/2) |> IO.inspect()
    IO.puts("part 1 = #{manhatten(ship)}")

    # Part 2
    part2 =
      Enum.reduce(instructions, Part2.new({0, 0}, {10, 1}), step(&Part2.execute/2))
      |> IO.inspect()

    IO.puts("part 2 = #{manhatten(part2.ship)}")
    # _part2 = Enum.reduce(instructions, Part2.new(), &Part2.execute/2) |> IO.inspect()
  end

  defp manhatten(%Part1.Ship{x: x, y: y}), do: abs(x) + abs(y)
  defp manhatten(%Part2.Pos{x: x, y: y}), do: abs(x) + abs(y)

  defp parse_instruction(line) do
    [action, value] = Regex.run(~r/^(N|E|S|W|L|R|F)(\d+)$/, line, capture: :all_but_first)
    {action, String.to_integer(value)}
  end

  defp step(f) do
    fn x, acc ->
      f.(x, acc) |> IO.inspect()
    end
  end
end
