defmodule Day2ex do
  def main(_args) do
    input =
      File.read!("input")
      |> String.split("\n")
      |> Enum.filter(fn
        "" -> false
        _ -> true
      end)
      |> Enum.map(fn line ->
        [min, max, ch, password] =
          Regex.run(~r/^(\d+)-(\d+)\s(.):\s(.+)$/, line, capture: :all_but_first)

        [String.to_integer(min), String.to_integer(max), ch, password]
      end)

    input
    |> Enum.count(fn [min, max, ch, password] ->
      count =
        password
        |> String.graphemes()
        |> Enum.count(fn
          ^ch -> true
          _ -> false
        end)

      min <= count && count <= max
    end) |> IO.inspect
  end
end
