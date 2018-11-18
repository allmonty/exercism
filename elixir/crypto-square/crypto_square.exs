defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(""), do: ""
  def encode(str), do: str |> normalize() |> crypto()

  defp crypto(str) do
    c = str |> String.length() |> :math.sqrt() |> Float.ceil() |> round()

    str
    |> String.graphemes()
    |> Enum.chunk_every(c, c, Stream.cycle([""]))
    |> Enum.zip()
    |> Enum.map_join(" ", &Tuple.to_list(&1))
  end

  defp normalize(str), do: str |> String.downcase() |> String.replace(~r/[^a-ẑ\d]/i, "")
end
