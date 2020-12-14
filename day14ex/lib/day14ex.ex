defmodule Day14ex do
  defmodule State1 do
    defstruct(
      # Extra underscore to line up values.
      mask_and: 0xFFFFFFFFF,
      mask__or: 0x000000000,
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
    mask_and = mask |> String.replace("X", "1") |> String.to_integer(2)
    mask__or = mask |> String.replace("X", "0") |> String.to_integer(2)
    %State1{state | mask_and: mask_and, mask__or: mask__or}
  end

  defp step1(line = "mem[" <> _rest, state) do
    use Bitwise

    [address, value] = Regex.run(~r/^mem\[(\d+)\] = (\d+)$/, line, capture: :all_but_first)

    address = String.to_integer(address, 10)
    value = String.to_integer(value, 10)

    value = value |> band(state.mask_and) |> bor(state.mask__or)

    %State1{state | mem: Map.put(state.mem, address, value)}
  end

  defp step2(_line = "mask = " <> mask, state) do
    %State2{state | mask: mask}
  end

  defp step2(line = "mem[" <> _rest, state) do
    [address, value] = Regex.run(~r/^mem\[(\d+)\] = (\d+)$/, line, capture: :all_but_first)

    address = String.to_integer(address, 10)
    value = String.to_integer(value, 10)

    # A mask is a pair of values:
    # - 'and' is the bits I want to manipulate;
    # - 'or' is the values I want in those bits.

    # If the bitmask bit is 0, the corresponding memory address bit is unchanged.
    # If the bitmask bit is 1, the corresponding memory address bit is overwritten with 1.
    # If the bitmask bit is X, the corresponding memory address bit is floating.

    # If the bitmask bit is 0, 'and' = 0, 'or' = 0
    # If the bitmask bit is 1, 'and' = 1, 'or' = 1
    # If the bitmask bit is X, 'and' = 1, 'or' = ...

    and_mask = generate_and_mask(state.mask)
    or_masks = generate_or_masks(state.mask)

    addresses =
      generate_addresses(address, and_mask, or_masks)
      |> IO.inspect()

    # mem = Enum.reduce(or_masks, state.mem, fn x -> end)

    state
    # %State2{state | mem: mem}
  end

  def generate_and_mask(mask), do: mask |> String.replace("X", "1") |> String.to_integer(2)

  def generate_or_masks(mask), do: generate_or_masks(mask, [0])

  def generate_or_masks("0" <> rest, masks) do
    next = Enum.flat_map(masks, fn m -> [Bitwise.bsl(m, 1) + 0] end)
    generate_or_masks(rest, next)
  end

  def generate_or_masks("1" <> rest, masks) do
    next = Enum.flat_map(masks, fn m -> [Bitwise.bsl(m, 1) + 1] end)
    generate_or_masks(rest, next)
  end

  def generate_or_masks("X" <> rest, masks) do
    next = Enum.flat_map(masks, fn m -> [Bitwise.bsl(m, 1) + 0, Bitwise.bsl(m, 1) + 1] end)
    generate_or_masks(rest, next)
  end

  def generate_or_masks("", masks), do: masks

  def generate_addresses(address, and_mask, or_masks) do
    for or_mask <- or_masks do
      address |> Bitwise.band(and_mask) |> Bitwise.bor(or_mask)
    end
  end
end
