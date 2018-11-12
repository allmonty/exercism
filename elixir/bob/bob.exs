defmodule Bob do
  def hey(input) do
    cond do
      yelling_question?(input) -> "Calm down, I know what I'm doing!"
      all_uppercase?(input) -> "Whoa, chill out!"
      question?(input) -> "Sure."
      nothing?(input) -> "Fine. Be that way!"
      true -> "Whatever."
    end
  end

  def all_uppercase?(input), do: String.match?(input, ~r/^[^a-z]+$/)
  def question?(input), do: String.match?(input, ~r/[?]$/)
  def yelling_question?(input), do: all_uppercase?(input) and question?(input)
  def nothing?(input), do: input == ""
end
