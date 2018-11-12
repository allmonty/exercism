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

  def all_uppercase?(input) do
    input
    |> String.replace(~r/[\d,? ]/, "")
    |> String.match?(~r/^[^a-z]+$/u)
  end

  def question?(input), do: input =~ ~r/[?]$/

  def nothing?(input), do: String.trim_leading(input) == ""

  def yelling_question?(input), do: all_uppercase?(input) and question?(input)
end
