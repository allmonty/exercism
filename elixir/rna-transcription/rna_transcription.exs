defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    dna
    |> Enum.reduce('', &(convert_to_rna(&1) ++ &2))
    |> Enum.reverse()
  end

  @dna_to_rna %{
    "A" => 'U',
    "C" => 'G',
    "T" => 'A',
    "G" => 'C'
  }

  defp convert_to_rna(dna) do
    dna = to_string([dna])
    @dna_to_rna[dna]
  end
end
