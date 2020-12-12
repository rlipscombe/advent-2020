defmodule Day12ex do
  defmodule Ship do
    defstruct x: 0, y: 0, facing: "E"
  end

  def main([path]) do
    instructions =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_instruction/1)

    ship = Enum.reduce(instructions, %Ship{}, &execute/2) |> IO.inspect()

    IO.puts("part 1 = #{manhatten(ship)}")
  end

  defp manhatten(%Ship{x: x, y: y}), do: abs(x) + abs(y)

  defp parse_instruction(line) do
    [action, value] = Regex.run(~r/^(N|E|S|W|L|R|F)(\d+)$/, line, capture: :all_but_first)
    {action, String.to_integer(value)}
  end

  defp execute({"N", n}, ship = %Ship{y: y}), do: %Ship{ship | y: y + n}
  defp execute({"E", n}, ship = %Ship{x: x}), do: %Ship{ship | x: x + n}
  defp execute({"S", n}, ship = %Ship{y: y}), do: %Ship{ship | y: y - n}
  defp execute({"W", n}, ship = %Ship{x: x}), do: %Ship{ship | x: x - n}

  defp execute({"L", n}, ship = %Ship{facing: facing}),
    do: %Ship{ship | facing: rotate_l(facing, n)}

  defp execute({"R", n}, ship = %Ship{facing: facing}),
    do: %Ship{ship | facing: rotate_r(facing, n)}

  defp execute({"F", n}, ship = %Ship{facing: facing}), do: execute({facing, n}, ship)

  defp rotate_l("N", 90), do: "W"
  defp rotate_l("E", 90), do: "N"
  defp rotate_l("S", 90), do: "E"
  defp rotate_l("W", 90), do: "S"
  defp rotate_l(facing, n), do: facing |> rotate_l(90) |> rotate_l(n - 90)

  defp rotate_r("N", 90), do: "E"
  defp rotate_r("E", 90), do: "S"
  defp rotate_r("S", 90), do: "W"
  defp rotate_r("W", 90), do: "N"
  defp rotate_r(facing, n), do: facing |> rotate_r(90) |> rotate_r(n - 90)
end
