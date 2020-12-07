defmodule Day7ex do
  def main(_args) do
    rules =
      File.read!("input")
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_rule/1)
  end

  defp parse_rule(s) do
    [outer, inners] = Regex.run(~r/^(.*) bags contain (.*).$/, s, capture: :all_but_first)
    {outer, parse_inners(inners)} |> IO.inspect
  end

  defp parse_inners("no other bags"), do: []
  defp parse_inners(s) do
    s |> String.split(", ") |> Enum.map(&parse_inner/1)
  end

  defp parse_inner(s) do
    [count, colour] = Regex.run(~r/(\d+) (.*) bags?/, s, capture: :all_but_first)
    {String.to_integer(count), colour}
  end
end
