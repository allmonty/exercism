defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) do
    next_beers = (number - 1) |> Integer.mod(100) |> qnt_of_bottles()

    """
    #{qnt_of_bottles(number, :capitalize)} of beer on the wall, #{qnt_of_bottles(number)} of beer.
    #{do_something(number)}, #{next_beers} of beer on the wall.
    """
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(), do: lyrics(99..0)

  def lyrics(range) do
    range
    |> Enum.reduce("", fn verse_num, text ->
      text <> verse(verse_num) <> break_line(verse_num, range)
    end)
  end

  def break_line(current, _..last) when current == last, do: ""
  def break_line(_, _), do: "\n"

  defp qnt_of_bottles(_, _ \\ nil)
  defp qnt_of_bottles(0, :capitalize), do: "No more bottles"
  defp qnt_of_bottles(0, _), do: "no more bottles"
  defp qnt_of_bottles(1, _), do: "1 bottle"
  defp qnt_of_bottles(n, _), do: "#{n} bottles"

  defp do_something(0), do: "Go to the store and buy some more"
  defp do_something(1), do: "Take it down and pass it around"
  defp do_something(_), do: "Take one down and pass it around"
end
