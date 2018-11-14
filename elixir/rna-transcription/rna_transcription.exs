defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna), do: Enum.map(dna, &convert/1)

  @dna_to_rna %{?A => ?U, ?C => ?G, ?T => ?A, ?G => ?C}

  defp convert(dna), do: @dna_to_rna[dna]
end
