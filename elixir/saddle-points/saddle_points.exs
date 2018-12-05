defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n")
    |> Enum.map(&split_to_integer/1)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    str
    |> rows()
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  #  (row, column)

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    bigger_per_row = str |> rows() |> bigger_per_row() |> MapSet.new()
    smaller_per_column = str |> columns() |> smaller_per_column() |> MapSet.new()

    MapSet.intersection(bigger_per_row, smaller_per_column) |> MapSet.to_list()
  end

  defp split_to_integer(str), do: str |> String.split() |> Enum.map(&String.to_integer/1)

  defp bigger_per_row(rows) do
    rows
    |> Enum.with_index()
    |> Enum.map(&row_bigger_or_equal/1)
    |> List.flatten()
  end

  defp row_bigger_or_equal({row, row_num}) do
    row
    |> Enum.with_index()
    |> Enum.reduce({[], 0}, fn {n, i}, {list, current} ->
      cond do
        n > current -> {[{row_num, i}], n}
        n == current -> {[{row_num, i} | list], n}
        true -> {list, current}
      end
    end)
    |> elem(0)
  end

  defp smaller_per_column(cols) do
    cols
    |> Enum.with_index()
    |> Enum.map(&column_smaller_or_equal/1)
    |> List.flatten()
  end

  defp column_smaller_or_equal({column, col_num}) do
    column
    |> Enum.with_index()
    |> Enum.reduce({[], -1}, fn {n, i}, {list, current} ->
      cond do
        n < current or current == -1 -> {[{i, col_num}], n}
        n == current -> {[{i, col_num} | list], n}
        true -> {list, current}
      end
    end)
    |> elem(0)
  end
end
