defmodule Bob do
  def hey(input) do
    cond do
      nothing?(input) -> "Fine. Be that way!"
      yelling_question?(input) -> "Calm down, I know what I'm doing!"
      all_uppercase?(input) -> "Whoa, chill out!"
      question?(input) -> "Sure."
      true -> "Whatever."
    end
  end

  def all_uppercase?(input) do
    String.match?(input, ~r/^[^a-z]*$/) and String.match?(input, ~r/[A-Z]+/)
  end

  def question?(input), do: String.match?(input, ~r/[?]$/)
  def yelling_question?(input), do: all_uppercase?(input) and question?(input)
  def nothing?(input), do: String.trim_leading(input) == ""
end
