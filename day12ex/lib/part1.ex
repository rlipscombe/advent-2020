defmodule Part1 do
  defmodule Ship do
    defstruct x: 0, y: 0, facing: "E"
  end

  def new(), do: %Ship{}

  def execute({"N", n}, ship = %Ship{y: y}), do: %Ship{ship | y: y + n}
  def execute({"E", n}, ship = %Ship{x: x}), do: %Ship{ship | x: x + n}
  def execute({"S", n}, ship = %Ship{y: y}), do: %Ship{ship | y: y - n}
  def execute({"W", n}, ship = %Ship{x: x}), do: %Ship{ship | x: x - n}

  def execute({"L", n}, ship = %Ship{facing: facing}),
    do: %Ship{ship | facing: rotate_l(facing, n)}

  def execute({"R", n}, ship = %Ship{facing: facing}),
    do: %Ship{ship | facing: rotate_r(facing, n)}

  def execute({"F", n}, ship = %Ship{facing: facing}), do: execute({facing, n}, ship)

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
