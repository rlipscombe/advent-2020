defmodule Day7ex do
  def main(_args) do
    name = "input"

    rules =
      File.read!(name)
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_rule/1)

    # Write that to a .png, so we can inspect it.
    #rules |> to_dot() |> dot_to_png(name)

    # Convert the rules to a digraph.
    g = Graph.new(type: :directed)

    g =
      Enum.reduce(rules, g, fn {outer, inners}, g ->
        Enum.reduce(inners, g, fn {count, inner}, g ->
          Graph.add_edge(g, outer, inner, weight: count)
        end)
      end)

    #Graph.to_dot(g) |> dot_to_png(name <> "g")

    # Then search for our bag colour. From there, how many roots are there?
    options = Graph.reaching(g, ["shiny gold"])

    length(options) - 1 |> IO.inspect
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

  defp to_dot(rules) do
    assigns = [rules: rules]

    dot =
      EEx.eval_string(
        """
        digraph G {
          <%= for {outer, inners} <- rules do %>
            <%= for {_, inner} <- inners do %>
              "<%= outer %>" -> "<%= inner %>";
            <% end %>
          <% end %>
        }
        """,
        assigns
      )

    {:ok, dot}
  end

  defp dot_to_png({:ok, dot}, name) do
    File.write!(name <> ".dot", dot)
    {_, 0} = System.cmd("dot", ["-Tpng", "-o", "#{name}.png", "#{name}.dot"])
  end
end
