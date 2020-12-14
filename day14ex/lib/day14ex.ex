defmodule Day14ex do
  defmodule State1 do
    defstruct(
      # Extra underscore to line up values.
      and_mask: 0xFFFFFFFFF,
      xor_mask: 0x000000000,
      mem: %{}
    )
  end

  defmodule State2 do
    defstruct(
      mask: "000000000000000000000000000000000000",
      mem: %{}
    )
  end

  def main([path]) do
    lines =
      File.read!(path)
      |> String.split("\n", trim: true)

    part1 = lines |> Enum.reduce(%State1{}, &step1/2)
    part1 = Enum.reduce(part1.mem, 0, fn {_addr, value}, acc -> acc + value end)

    IO.puts("part 1 = #{inspect(part1)}")

    part2 = lines |> Enum.reduce(%State2{}, &step2/2)
    part2 = Enum.reduce(part2.mem, 0, fn {_addr, value}, acc -> acc + value end)

    IO.puts("part 2 = #{inspect(part2)}")
  end

  defp step1(_line = "mask = " <> mask, state) do
    # A 0 or 1 overwrites the corresponding bit, while an X leaves it unchanged.
    # This means that, for an X in the mask, we need AND=1, XOR=0
    and_mask = mask |> String.replace("X", "1") |> String.to_integer(2)
    xor_mask = mask |> String.replace("X", "0") |> String.to_integer(2)
    %State1{state | and_mask: and_mask, xor_mask: xor_mask}
  end

  defp step1(line = "mem[" <> _rest, state) do
    use Bitwise

    [address, value] = Regex.run(~r/^mem\[(\d+)\] = (\d+)$/, line, capture: :all_but_first)

    address = String.to_integer(address, 10)
    value = String.to_integer(value, 10)

    value = value |> band(state.and_mask) |> bxor(state.xor_mask)

    %State1{state | mem: Map.put(state.mem, address, value)}
  end

  defp step2(_line = "mask = " <> mask, state) do
    %State2{state | mask: mask}
  end

  defp step2(line = "mem[" <> _rest, state) do
    [address, value] = Regex.run(~r/^mem\[(\d+)\] = (\d+)$/, line, capture: :all_but_first)

    address = String.to_integer(address, 10)
    value = String.to_integer(value, 10)

    addresses = AddressGenerator.generate_addresses(address, state.mask)

    mem = Enum.reduce(addresses, state.mem, fn a, m -> Map.put(m, a, value) end)
    %State2{state | mem: mem}
  end
end
