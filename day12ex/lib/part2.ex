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

  def execute({"R", 90}, state = %State{waypoint: %Rel{dx: dx, dy: dy}}) do
    %State{state | waypoint: %Rel{dx: dy, dy: -dx}}
  end
end
