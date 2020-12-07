defmodule Day7ex do
  def main([name]) do
    rules =
      File.read!(name)
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_rule/1)

    # Convert the rules to a digraph.
    g = Graph.new(type: :directed)

    g =
      Enum.reduce(rules, g, fn {outer, inners}, g ->
        Enum.reduce(inners, g, fn {count, inner}, g ->
          Graph.add_edge(g, outer, inner, label: "#{count}", weight: count)
        end)
      end)

    # Write that to a .png, so we can inspect it.
    # Note: This is not useful with the full input.
    # Graph.to_dot(g) |> dot_to_png(name)

    # Then search for my bag. From there, how many roots are there?
    my_bag = "shiny gold"
    options = Graph.reaching(g, [my_bag])

    part1 = length(options) - 1
    IO.puts("part 1: #{part1}")

    contents = Graph.reachable(g, [my_bag])

    subgraph = Graph.subgraph(g, contents)
    Graph.to_dot(subgraph) |> dot_to_png(name <> "-sg")

    part2 = count_bags(subgraph, my_bag) - 1
    IO.puts("part 2: #{part2}")
  end

  defp parse_rule(s) do
    [outer, inners] = Regex.run(~r/^(.*) bags contain (.*).$/, s, capture: :all_but_first)
    {outer, parse_inners(inners)}
  end

  defp parse_inners("no other bags"), do: []

  defp parse_inners(s) do
    s |> String.split(", ") |> Enum.map(&parse_inner/1)
  end

  defp parse_inner(s) do
    [count, colour] = Regex.run(~r/(\d+) (.*) bags?/, s, capture: :all_but_first)
    {String.to_integer(count), colour}
  end

  defp dot_to_png({:ok, dot}, name) do
    File.write!(name <> ".dot", dot)
    {_, 0} = System.cmd("dot", ["-Tpng", "-o", "#{name}.png", "#{name}.dot"])
  end

  defp count_bags(g, v) do
    Graph.out_edges(g, v)
    |> Enum.reduce(1, fn %Graph.Edge{weight: w, v2: v2}, acc ->
      acc + w * count_bags(g, v2)
    end)
  end
end
