defmodule Day13ex do
  def main([path]) do
    [timestamp, line2] =
      File.read!(path)
      |> String.split("\n", trim: true)

    timestamp = String.to_integer(timestamp) |> IO.inspect()

    schedule =
      line2
      |> String.split(",", trim: true)
      |> Enum.filter(fn x -> x != "x" end)
      |> Enum.map(&String.to_integer/1)
      |> IO.inspect()

    departures =
      for bus <- schedule do
        next = timestamp + bus - rem(timestamp, bus)
        {bus, next}
      end

    {id, at} = departures |> Enum.min_by(fn {_id, at} -> at end)
    wait = at - timestamp
    result = id * wait
    IO.puts("part 1: bus #{id} departs at #{at}; wait is #{wait}; result is #{result}")

    # solve(parse("3,5")) |> IO.inspect()
    # solve(parse("17,x,13,19")) |> IO.inspect()
    # solve(parse("67,7,59,61")) |> IO.inspect()
    # solve(parse("67,x,7,59,61")) |> IO.inspect()
    # solve(parse("67,7,x,59,61")) |> IO.inspect()
    # solve(parse("1789,37,47,1889")) |> IO.inspect()

    values = parse(line2)
    solve(values) |> IO.inspect()
  end

  defp parse(line2) do
    line2
    |> String.split(",", trim: true)
    |> Enum.map(fn
      "x" -> nil
      n -> String.to_integer(n)
    end)
    |> Enum.with_index()
    |> Enum.filter(fn
      {nil, _} -> false
      _ -> true
    end)
    |> Enum.map(fn {id, of} -> {Integer.mod(-of, id), id} end)
    |> Enum.sort(fn {_, a}, {_, b} -> a > b end)
  end

  defp solve([{a1, n1}, {a2, n2} | rest]) do
    case Integer.mod(a1, n2) == a2 do
      true -> solve([{a1, n1 * n2} | rest])
      _ -> solve([{a1 + n1, n1}, {a2, n2} | rest])
    end
  end

  defp solve([{a1, _n1}]), do: a1
end
