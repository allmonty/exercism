defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  import Calendar.ISO, only: [days_in_month: 2, day_of_week: 3]

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    day =
      year
      |> days_by_weekday(month)
      |> get_by_weekday(weekday)
      |> find_by_schedule(schedule)

    {year, month, day}
  end

  defp days_by_weekday(year, month) do
    days_in_month(year, month)..1
    |> Enum.reduce(%{}, fn day, acc ->
      day_of_week = day_of_week(year, month, day)
      Map.update(acc, day_of_week, [day], &[day | &1])
    end)
  end

  defp get_by_weekday(days_by_weekday, weekday),
    do: Map.get(days_by_weekday, parsed_weekdays()[weekday], [])

  defp find_by_schedule(days, :first), do: List.first(days)
  defp find_by_schedule(days, :second), do: Enum.at(days, 1)
  defp find_by_schedule(days, :third), do: Enum.at(days, 2)
  defp find_by_schedule(days, :fourth), do: Enum.at(days, 3)
  defp find_by_schedule(days, :last), do: List.last(days)
  defp find_by_schedule(days, :teenth), do: Enum.find(days, &(&1 in teenths()))

  defp teenths, do: [13, 14, 15, 16, 17, 18, 19]

  defp parsed_weekdays do
    %{
      monday: 1,
      tuesday: 2,
      wednesday: 3,
      thursday: 4,
      friday: 5,
      saturday: 6,
      sunday: 7
    }
  end
end
