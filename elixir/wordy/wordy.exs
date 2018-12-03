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

  defp process([n]), do: n

  defp process([a, "plus", b | t]), do: process([a + b | t])

  defp convert_numbers(str) do
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
