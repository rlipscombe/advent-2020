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

    input |> Enum.count(&new_rules/1) |> IO.inspect()
  end

  defp old_rules([min, max, ch, password]) do
    count =
      password
      |> String.graphemes()
      |> Enum.count(fn
        ^ch -> true
        _ -> false
      end)

    min <= count && count <= max
  end

  defp new_rules([a, b, ch, password]) do
    case {String.at(password, a - 1), String.at(password, b - 1)} do
      {^ch, ^ch} -> false
      {^ch, _} -> true
      {_, ^ch} -> true
      {_, _} -> false
    end
  end
end
