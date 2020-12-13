defmodule Day13ex do
  def main([path]) do
    [timestamp, schedule] =
      File.read!(path)
      |> String.split("\n", trim: true)

    timestamp = String.to_integer(timestamp) |> IO.inspect()

    schedule =
      schedule
      |> String.split(",", trim: true)
      |> Enum.filter(fn x -> x != "x" end)
      |> Enum.map(&String.to_integer/1)
      |> IO.inspect()

    departures = for bus <- schedule do
      next = timestamp + bus - rem(timestamp, bus)
      {bus, next}
    end

    {id, at} = departures |> Enum.min_by(fn {_id, at} -> at end)
    wait = at - timestamp
    result = id * wait
    IO.puts("part 1: bus #{id} departs at #{at}; wait is #{wait}; result is #{result}")
  end
end
