defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(equation) do
    equation
    |> String.trim_trailing("?")
    |> String.split()
    |> process()
  end

  defp process([n]) when is_number(n), do: n
  defp process(["What", "is" | t]), do: process(t)
  defp process([a, "plus", b | t]), do: process([plus(a, b) | t])
  defp process([a, "minus", b | t]), do: process([minus(a, b) | t])
  defp process([a, "multiplied", "by", b | t]), do: process([multi(a, b) | t])
  defp process([a, "divided", "by", b | t]), do: process([divide(a, b) | t])
  defp process([a, "raised", "to", "the", b, "power" | t]), do: process([pow(a, b) | t])
  defp process(_), do: raise(ArgumentError)

  defp plus(a, b), do: to_number(a) + to_number(b)
  defp minus(a, b), do: to_number(a) - to_number(b)
  defp multi(a, b), do: to_number(a) * to_number(b)
  defp divide(a, b), do: to_number(a) / to_number(b)
  defp pow(a, b), do: :math.pow(to_number(a), to_number(b))

  defp to_number(text) when is_number(text), do: text
  defp to_number(text), do: text |> remove_ordinal() |> to_numeric()

  defp to_numeric(text) do
    cond do
      text =~ ~r/^-?\d+$/ -> String.to_integer(text)
      text =~ ~r/^-?\d+[,.]\d+$/ -> String.to_float(text)
      true -> raise(ArgumentError)
    end
  end

  defp remove_ordinal(str), do: String.replace(str, ~r/(st|nd|rd|th)$/, "")
end
