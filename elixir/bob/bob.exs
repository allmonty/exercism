defmodule Bob do
  def hey(input) do
    cond do
      all_uppercase?(input) -> "Whoa, chill out!"
      question?(input) -> "Sure."
      true -> "Whatever."
    end
  end

  def all_uppercase?(input), do: String.match?(input, ~r/^[^a-z]*$/)
  def question?(input), do: String.match?(input, ~r/[?]/)
end
