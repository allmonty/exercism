defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _), do: %{}

  def frequency(texts, workers) do
    texts
    |> Task.async_stream(&calculate_frequency/1, max_concurrency: workers)
    |> Enum.reduce(%{}, fn {:ok, num}, acc ->
      Map.merge(num, acc, fn _k, x, y -> x + y end)
    end)
  end

  defp calculate_frequency(text) do
    text
    |> String.replace(~r/[^a-ẑ]/i, "")
    |> String.downcase()
    |> String.graphemes()
    |> Enum.reduce(%{}, &increment_into_map/2)
  end

  defp increment_into_map(item, map), do: Map.update(map, item, 1, &(&1 + 1))
end
