defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.replace(~r/[^a-ẑ\s\d-_]/i, "")
    |> String.downcase()
    |> String.split(~r/[\s_]+/)
    |> Enum.reduce(%{}, &increment_into_map/2)
  end

  defp increment_into_map(item, map), do: Map.update(map, item, 1, &(&1 + 1))
end
