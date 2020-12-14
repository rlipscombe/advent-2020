defmodule Day14ex do
  defmodule State do
    defstruct(
      # Extra underscore to line up values.
      mask_and: 0xFFFFFFFFF,
      mask__or: 0x000000000,
      mem: %{}
    )
  end

  def main([path]) do
    lines =
      File.read!(path)
      |> String.split("\n", trim: true)

    final = lines |> Enum.reduce(%State{}, &step/2)

    IO.puts("#{inspect(final)}")
  end

  defp step(_line = "mask = " <> mask, state) do
    mask_and = mask |> String.replace("X", "1") |> String.to_integer(2)
    mask__or = mask |> String.replace("X", "0") |> String.to_integer(2)
    %State{state | mask_and: mask_and, mask__or: mask__or}
  end

  defp step(line = "mem[" <> _rest, state) do
    use Bitwise

    [address, value] =
      Regex.run(~r/^mem\[(\d+)\] = (\d+)$/, line, capture: :all_but_first) |> IO.inspect()

    address = String.to_integer(address, 10)
    value = String.to_integer(value, 10)

    value = value |> band(state.mask_and) |> bor(state.mask__or)

    %State{state | mem: Map.put(state.mem, address, value)}
  end
end
