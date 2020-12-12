defmodule Day12ex do
  def main([path]) do
    instructions =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_instruction/1)

    ship = Enum.reduce(instructions, %Ship{}, &Part1.execute/2) |> IO.inspect()

    IO.puts("part 1 = #{manhatten(ship)}")
  end

  defp manhatten(%Ship{x: x, y: y}), do: abs(x) + abs(y)

  defp parse_instruction(line) do
    [action, value] = Regex.run(~r/^(N|E|S|W|L|R|F)(\d+)$/, line, capture: :all_but_first)
    {action, String.to_integer(value)}
  end
end
