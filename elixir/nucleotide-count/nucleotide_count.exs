defmodule NucleotideCount do
  @summary %{?A => 0, ?C => 0, ?G => 0, ?T => 0}

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide), do: Enum.reduce(strand, 0, &((&1 == nucleotide && &2 + 1) || &2))

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram([char]) :: map
  def histogram(strand), do: Enum.reduce(strand, @summary, &%{&2 | &1 => &2[&1] + 1})
end
