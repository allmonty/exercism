defmodule Forth do
  @opaque evaluator :: any

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    []
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s
    |> separate()
    |> map_integers()
    |> calculate([])
    |> Enum.reverse()
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    ev |> Enum.join(" ")
  end

  defp separate(s) do
    s |> String.split(~r/[^a-zA-Z\d\-\+\/\*]+/)
  end

  defp map_integers(s) do
    Enum.map(s, fn x ->
      cond do
        x =~ ~r/^-?\d+$/ -> String.to_integer(x)
        true -> x
      end
    end)
  end

  defp calculate([], values), do: values

  defp calculate([h | t], values) do
    case h do
      "+" -> calculate(t, plus(values))
      "-" -> calculate(t, sub(values))
      "*" -> calculate(t, mult(values))
      "/" -> calculate(t, div(values))
      value -> calculate(t, [value | values])
    end
  end

  defp plus([a, b]), do: [b + a]
  defp sub([a, b]), do: [b - a]
  defp mult([a, b]), do: [b * a]
  defp div([a, b]), do: [Integer.floor_div(b, a)]

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
