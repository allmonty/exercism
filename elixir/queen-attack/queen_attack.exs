defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct black: nil, white: nil

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new(), do: %{white: {0, 3}, black: {7, 3}}
  def new(white, black) when white == black, do: raise(ArgumentError)
  def new(white, black), do: %{white: white, black: black}

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    0..7
    |> Enum.flat_map(fn l -> Enum.map(0..7, fn c -> {l, c} end) end)
    |> Enum.map(fn x -> calculate_piece(x, queens) <> suffix(x) end)
    |> Enum.join()
    |> String.trim_trailing(" ")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(queens), do: do_can_attack?(queens.black, queens.white)

  defp do_can_attack?({xcol, _}, {ycol, _}) when xcol == ycol, do: true
  defp do_can_attack?({_, xrow}, {_, yrow}) when xrow == yrow, do: true
  defp do_can_attack?({xcol, xrow}, {ycol, yrow}), do: abs(xcol - ycol) == abs(xrow - yrow)

  defp calculate_piece({col, row}, queens) do
    cond do
      {col, row} == queens.white -> "W"
      {col, row} == queens.black -> "B"
      true -> "_"
    end
  end

  defp suffix({col, row}) do
    cond do
      {col, row} == {7, 7} -> ""
      row == 7 and col != 7 -> "\n"
      true -> " "
    end
  end
end
