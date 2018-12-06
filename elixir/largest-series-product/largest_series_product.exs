defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer

  def largest_product(_, size) when size < 0, do: raise(ArgumentError)
  def largest_product(str, size) when byte_size(str) < size, do: raise(ArgumentError)

  def largest_product(number_string, size) do
    number_string
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> calculate(size)
  end

  defp calculate(list, size) do
    iterations = length(list) - size

    Enum.reduce(0..iterations, 0, fn i, acc ->
      list
      |> Enum.slice(i, size)
      |> Enum.reduce(1, &(&1 * &2))
      |> case do
        x when x > acc -> x
        _ -> acc
      end
    end)
  end
end
