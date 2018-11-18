defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(""), do: ""

  def encode(str) do
    str
    |> normalize()
    |> crypto()
  end

  defp normalize(str), do: str |> String.downcase() |> String.replace(~r/[^a-ẑ\d]/i, "")

  defp crypto(str) do
    {c, r} = calc_c_r(str)

    str
    |> String.pad_trailing(c * r)
    |> String.graphemes()
    |> Enum.chunk_every(c)
    |> Enum.zip()
    |> Enum.map_join(" ", fn x ->
      x |> Tuple.to_list() |> Enum.join() |> String.trim()
    end)
  end

  defp calc_c_r(str) do
    side = str |> String.length() |> :math.sqrt()
    c = side |> Float.ceil() |> round()
    r = side |> Float.floor() |> round()
    {c, r}
  end
end
