defmodule Roman do
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

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number), do: calc(number, @numerals)

  defp calc(num, [{ref, numeral} | _]) when num == ref, do: numeral
  defp calc(num, [{ref, _} | numerals]) when num < ref, do: calc(num, numerals)
  defp calc(num, [{ref, numeral} | _] = list) when num > ref, do: numeral <> calc(num - ref, list)
end
