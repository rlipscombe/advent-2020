defmodule AddressGenerator do
  def generate_addresses(address, mask) do
    # Remember: https://docs.microsoft.com/en-us/windows-hardware/drivers/display/drawing-monochrome-pointers
    #  AND  XOR   Result
    #   0    0     0
    #   0    1     1
    #   1    0     same
    #   1    1     inverse

    # If the bitmask bit is 0, the corresponding memory address bit is unchanged.
    # If the bitmask bit is 1, the corresponding memory address bit is overwritten with 1.
    # If the bitmask bit is X, the corresponding memory address bit is floating.

    # If the bitmask bit is 0: 'and' = 1, 'xor' = 0 => unchanged
    # If the bitmask bit is 1: 'and' = 0, 'xor' = 1 => set 1
    # If the bitmask bit is X: 'and' = 0, 'xor' <- {0, 1}

    masks = generate_masks(mask)
#    masks |> IO.inspect()

#    address |> Integer.to_string(2) |> IO.inspect()
    for {and_mask, xor_mask} <- masks do
#      and_mask |> Integer.to_string(2) |> IO.inspect()
#      xor_mask |> Integer.to_string(2) |> IO.inspect()
      a = address |> Bitwise.band(and_mask) |> Bitwise.bxor(xor_mask)
      #a |> Integer.to_string(2) |> IO.inspect()
      a
    end
  end

  def generate_masks(mask), do: generate_masks(mask, [{1, 0}])

  defp generate_masks("0" <> rest, acc) do
    next =
      Enum.map(
        acc,
        fn {a, x} ->
          {Bitwise.bsl(a, 1) + 1, Bitwise.bsl(x, 1) + 0}
        end
      )

    generate_masks(rest, next)
  end

  defp generate_masks("1" <> rest, acc) do
    next =
      Enum.map(
        acc,
        fn {a, x} ->
          {Bitwise.bsl(a, 1) + 0, Bitwise.bsl(x, 1) + 1}
        end
      )

    generate_masks(rest, next)
  end

  defp generate_masks("X" <> rest, acc) do
    next =
      Enum.flat_map(
        acc,
        fn {a, x} ->
          [
            {Bitwise.bsl(a, 1) + 0, Bitwise.bsl(x, 1) + 0},
            {Bitwise.bsl(a, 1) + 0, Bitwise.bsl(x, 1) + 1}
          ]
        end
      )

    generate_masks(rest, next)
  end

  defp generate_masks("", acc), do: acc
end
