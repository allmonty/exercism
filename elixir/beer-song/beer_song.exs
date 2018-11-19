defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) do
    current_beers = quantity_of_bottles(number)
    next_beers = (number - 1) |> Integer.mod(100) |> quantity_of_bottles()

    """
    #{current_beers} of beer on the wall, #{current_beers} of beer.
    #{do_something(number)}, #{next_beers} of beer on the wall.
    """
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range) do
    # Your implementation here...
  end

  defp quantity_of_bottles(0), do: "No more bottles"
  defp quantity_of_bottles(1), do: "1 bottle"
  defp quantity_of_bottles(n), do: "#{n} bottles"

  defp do_something(0), do: "Go to the store and buy some more"
  defp do_something(1), do: "Take it down and pass it around"
  defp do_something(_), do: "Take one down and pass it around"
end
