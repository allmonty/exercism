defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list), do: do_flat(list, []) |> reverse([])

  defp do_flat([], f), do: f
  defp do_flat([nil | t], f), do: do_flat(t, f)
  defp do_flat([h | t], f) when is_list(h), do: do_flat(t, do_flat(h, f))
  defp do_flat([h | t], f), do: do_flat(t, [h | f])

  defp reverse([], r), do: r
  defp reverse([h | t], r), do: reverse(t, [h | r])
end
