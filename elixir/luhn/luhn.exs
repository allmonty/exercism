defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    number
    |> String.replace(" ", "")
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> double_every_second_from_right()
    |> divisible_by_10?()
  end

  defp divisible_by_10?(0), do: false
  defp divisible_by_10?(number), do: rem(number, 10) == 0

  defp double_every_second_from_right(number_list) do
    number_list
    |> Enum.reverse()
    |> Enum.zip(Stream.cycle([0, 1]))
    |> Enum.reduce(0, fn {x, m}, acc ->
      r = x * (m + 1)
      (r > 9 && r - 9 + acc) || r + acc
    end)
  end
end
