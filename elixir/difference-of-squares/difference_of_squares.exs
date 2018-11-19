defmodule Squares do
  @moduledoc """
  Calculate sum of squares, square of sum, difference between two sums from 1 to a given end number.
  """

  @doc """
  Calculate sum of squares from 1 to a given end number.
  """
  @spec sum_of_squares(pos_integer) :: pos_integer
  def sum_of_squares(number), do: sum(number, &square/1)

  @doc """
  Calculate square of sum from 1 to a given end number.
  """
  @spec square_of_sum(pos_integer) :: pos_integer
  def square_of_sum(number), do: square(sum(number))

  @doc """
  Calculate difference between sum of squares and square of sum from 1 to a given end number.
  """
  @spec difference(pos_integer) :: pos_integer
  def difference(number), do: square_of_sum(number) - sum_of_squares(number)

  defp square(n), do: :math.pow(n, 2)
  defp sum(n, modifier \\ & &1), do: Enum.reduce(1..n, 0, &(&2 + modifier.(&1)))
end
