defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer("What is " <> equation) do
    equation
    |> String.trim_trailing("?")
    |> String.split(" ")
    |> Enum.map(&convert_numbers/1)
    |> process()
  end

  def answer(_), do: raise(ArgumentError)

  defp process([n]), do: n
  defp process([a, "plus", b | t]), do: process([a + b | t])
  defp process([a, "minus", b | t]), do: process([a - b | t])
  defp process([a, "multiplied", "by", b | t]), do: process([a * b | t])
  defp process([a, "divided", "by", b | t]), do: process([a / b | t])
  defp process([a, "raised", "to", "the", b, "power" | t]), do: process([:math.pow(a, b) | t])
  defp process(_), do: raise(ArgumentError)

  defp convert_numbers(str) do
    str = String.replace(str, ~r/(st|nd|rd|th)$/, "")

    try do
      String.to_integer(str)
    rescue
      ArgumentError ->
        try do
          String.to_float(str)
        rescue
          ArgumentError -> str
        end
    end
  end
end
