defmodule Day1 do
  def main(_args) do
    input =
      File.read!("input") |> String.split() |> Enum.map(&String.to_integer/1) |> Enum.with_index()

    for {x, ix} <- input, {y, iy} <- input, {z, iz} <- input, ix != iy, iy != iz, ix != iz do
      if x + y + z == 2020 do
        IO.puts(x * y * z)
      end
    end
  end
end
