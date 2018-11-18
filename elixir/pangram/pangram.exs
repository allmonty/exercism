defmodule Pangram do
  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(""), do: false

  def pangram?(sentence) do
    sentence
    |> normalize()
    |> String.graphemes()
    |> Enum.reduce(bucket(), fn x, acc -> %{acc | x => acc[x] + 1} end)
    |> Enum.any?(fn {_, value} -> value == 0 end)
    |> Kernel.!()
  end

  defp normalize(str), do: str |> String.downcase() |> String.replace(~r/[^a-ẑ\d]/i, "")

  defp bucket() do
    "abcdefghijklmnopqrstuvwxyz"
    |> String.graphemes()
    |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x, 0) end)
  end
end
