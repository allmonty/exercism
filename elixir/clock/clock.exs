defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) do
    total_minutes = hour * 60 + minute
    create(total_minutes)
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    total_minutes = hour * 60 + minute + add_minute
    create(total_minutes)
  end

  # ------------- ------------- ------------- #

  defp minutes_to_hours(min), do: min |> Integer.floor_div(60) |> Integer.mod(24)
  defp limit_min_to_60(min), do: min |> Integer.mod(60)

  defp create(total_minutes) do
    %Clock{
      hour: total_minutes |> minutes_to_hours(),
      minute: total_minutes |> limit_min_to_60()
    }
  end
end

defimpl String.Chars, for: Clock do
  def to_string(clock) do
    hour = clock.hour |> time_padding()
    minute = clock.minute |> time_padding()
    "#{hour}:#{minute}"
  end

  defp time_padding(x), do: x |> Kernel.to_string() |> String.pad_leading(2, "0")
end
