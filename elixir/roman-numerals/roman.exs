defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number), do: calc(number)

  @numerals [
    {1000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  ]

  defp calc(number) do
    @numerals
    |> Enum.reduce({number, ""}, fn {key, numeral}, {remnant, acc} ->
      times = Integer.floor_div(remnant, key)
      {remnant - key * times, acc <> String.duplicate(numeral, times)}
    end)
    |> elem(1)
  end
end
