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
    for c <- 0..7, l <- 0..7 do
      cond do
        {c, l} == queens.white -> "W"
        {c, l} == queens.black -> "B"
        true -> "_"
      end <>
        cond do
          {c, l} == {7, 7} -> ""
          l == 7 and c != 7 -> "\n"
          true -> " "
        end
    end
    |> Enum.join()
    |> String.trim_trailing(" ")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(queens) do
  end
end
