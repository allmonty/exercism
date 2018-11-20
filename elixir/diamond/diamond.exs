defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    build(letter, letter, :any)
  end

  defp build(?A, letter, _) do
    side_spaces = String.duplicate(" ", letter - ?A)
    side_spaces <> "A" <> side_spaces <> "\n"
  end

  defp build(current, letter, _) when current == letter do
    build(current - 1, letter, :left) <>
      line(current, letter) <> build(current - 1, letter, :right)
  end

  defp build(current, letter, :left) do
    build(current - 1, letter, :left) <> line(current, letter)
  end

  defp build(current, letter, :right) do
    line(current, letter) <> build(current - 1, letter, :right)
  end

  defp line(current, letter) do
    s_current = [current] |> to_string()
    side_spaces = side_spaces(current, letter)
    middle_spaces = middle_spaces(current, letter)
    side_spaces <> s_current <> middle_spaces <> s_current <> side_spaces <> "\n"
  end

  defp middle_spaces(current, _), do: String.duplicate(" ", (current - ?A) * 2 - 1)
  defp side_spaces(current, letter), do: String.duplicate(" ", letter - current)
end
