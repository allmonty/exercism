defmodule Diamond do
  import String, only: [duplicate: 2]

  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    left_half = half(letter - 1, letter) |> Enum.reverse() |> Enum.join()
    right_half = half(letter - 1, letter) |> Enum.join()
    left_half <> line(letter, letter) <> right_half
  end

  defp half(curr, _) when curr < ?A, do: []
  defp half(curr, letter), do: [line(curr, letter) | half(curr - 1, letter)]

  defp line(?A, letter), do: side_spaces(?A, letter) <> "A" <> side_spaces(?A, letter) <> "\n"

  defp line(curr, letter) do
    s_curr = [curr] |> to_string()
    side_spaces = side_spaces(curr, letter)
    middle_spaces = middle_spaces(curr, letter)
    side_spaces <> s_curr <> middle_spaces <> s_curr <> side_spaces <> "\n"
  end

  defp middle_spaces(curr, _), do: duplicate(" ", (curr - ?A) * 2 - 1)
  defp side_spaces(curr, letter), do: duplicate(" ", letter - curr)
end
