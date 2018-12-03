defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(equation) do
    equation
    |> String.trim_trailing("?")
    |> String.split(" ")
    |> Enum.map(&convert_numbers/1)
    |> process()
  end

  defp process([n]), do: n
  defp process(["What", "is" | t]), do: process(t)
  defp process([a, "plus", b | t]), do: process([a + b | t])
  defp process([a, "minus", b | t]), do: process([a - b | t])
  defp process([a, "multiplied", "by", b | t]), do: process([a * b | t])
  defp process([a, "divided", "by", b | t]), do: process([a / b | t])
  defp process([a, "raised", "to", "the", b, "power" | t]), do: process([:math.pow(a, b) | t])
  defp process(_), do: raise(ArgumentError)

  defp convert_numbers(str) do
    str
    |> remove_ordinal()
    |> to_interger_or_pass()
    |> to_float_or_pass()
  end

  defp to_interger_or_pass(str_num) do
    try do
      String.to_integer(str_num)
    rescue
      ArgumentError -> str_num
    end
  end

  defp to_float_or_pass(str_num) do
    try do
      String.to_float(str_num)
    rescue
      ArgumentError -> str_num
    end
  end

  defp remove_ordinal(str), do: String.replace(str, ~r/(st|nd|rd|th)$/, "")
end
