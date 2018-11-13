defmodule Bob do
  def hey(input) do
    cond do
      nothing?(input) -> "Fine. Be that way!"
      yelling_question?(input) -> "Calm down, I know what I'm doing!"
      question?(input) -> "Sure."
      all_uppercase?(input) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end

  defp all_uppercase?(input) do
    input
    |> String.replace(~r/[\d,? ]/, "")
    |> String.match?(~r/^[^a-z]+$/u)
  end

  defp question?(input), do: input =~ ~r/[?]$/

  defp nothing?(input), do: String.trim_leading(input) == ""

  defp yelling_question?(input), do: all_uppercase?(input) and question?(input)
end
