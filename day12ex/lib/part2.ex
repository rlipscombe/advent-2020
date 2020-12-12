defmodule Part2 do
  defmodule Pos do
    defstruct x: 0, y: 0
  end

  defmodule Rel do
    defstruct dx: 0, dy: 0
  end

  defmodule State do
    defstruct ship: %Pos{}, waypoint: %Rel{}
  end

  def new({x, y}, {dx, dy}),
    do: %State{ship: %Pos{x: x, y: y}, waypoint: %Rel{dx: dx, dy: dy}}

  def execute({"N", n}, state = %State{waypoint: waypoint = %Rel{dy: dy}}),
    do: %State{state | waypoint: %Rel{waypoint | dy: dy + n}}

  def execute({"E", n}, state = %State{waypoint: waypoint = %Rel{dx: dx}}),
    do: %State{state | waypoint: %Rel{waypoint | dx: dx + n}}

  def execute({"S", n}, state = %State{waypoint: waypoint = %Rel{dy: dy}}),
    do: %State{state | waypoint: %Rel{waypoint | dy: dy - n}}

  def execute({"W", n}, state = %State{waypoint: waypoint = %Rel{dx: dx}}),
    do: %State{state | waypoint: %Rel{waypoint | dx: dx - n}}

  def execute(
        {"F", n},
        state = %State{ship: %Pos{x: x, y: y}, waypoint: %Rel{dx: dx, dy: dy}}
      ),
      do: %State{state | ship: %Pos{x: x + n * dx, y: y + n * dy}}

  def execute({"L", n}, state), do: rotate_l(n, state)
  def execute({"R", n}, state), do: rotate_r(n, state)

  def rotate_l(90, state = %State{waypoint: %Rel{dx: dx, dy: dy}}) do
    %State{state | waypoint: %Rel{dx: -dy, dy: dx}}
  end

  def rotate_l(n, state), do: rotate_l(n - 90, rotate_l(90, state))

  def rotate_r(90, state = %State{waypoint: %Rel{dx: dx, dy: dy}}) do
    %State{state | waypoint: %Rel{dx: dy, dy: -dx}}
  end

  def rotate_r(n, state), do: rotate_r(n - 90, rotate_r(90, state))
end
