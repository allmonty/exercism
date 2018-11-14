defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do
    calc(number, 5)
  end

  defp calc(0, _), do: ""

  defp calc(number, base) do
    base_minus_one = base - 1

    case rem(number, base) do
      0 -> "V"
      ^base_minus_one -> "IV"
      _ -> "I" <> calc(number - 1, base)
    end
  end

  @numerals %{
    1 => "I",
    5 => "V",
    10 => "X",
    50 => "L",
    100 => "C",
    500 => "D",
    1000 => "M"
  }
end
