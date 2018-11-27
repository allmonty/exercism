defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key), do: do_search(numbers, key, 0, tuple_size(numbers) - 1)

  defp do_search({}, _, _, _), do: :not_found
  defp do_search(_, _, left, right) when left > right, do: :not_found

  defp do_search(numbers, key, left, right) do
    mid = average(left, right)

    case elem(numbers, mid) do
      x when x > key -> do_search(numbers, key, left, mid - 1)
      x when x < key -> do_search(numbers, key, mid + 1, right)
      _ -> {:ok, mid}
    end
  end

  defp average(x, y), do: Integer.floor_div(x + y, 2)
end
