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
  def pangram?(sentence) do
    sentence
    |> normalize()
    |> String.graphemes()
    |> Enum.reduce(bucket(), &count_letters/2)
    |> Enum.any?(fn {_, value} -> value == 0 end)
    |> Kernel.!()
  end

  defp normalize(str), do: str |> String.replace(~r/[^a-zA-Z]/i, "") |> String.downcase()

  defp count_letters(x, map), do: %{map | x => map[x] + 1}

  defp bucket() do
    "abcdefghijklmnopqrstuvwxyz"
    |> String.graphemes()
    |> Enum.reduce(%{}, &Map.put(&2, &1, 0))
  end
end
