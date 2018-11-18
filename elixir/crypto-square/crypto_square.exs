defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(str) do
    str
    |> normalize()
  end

  defp normalize(str), do: str |> String.downcase() |> String.replace(~r/[^a-ẑ]/i, "")
end
