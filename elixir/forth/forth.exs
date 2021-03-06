defmodule Forth do
  @type evaluator :: any

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %{
      rules: %{
        "dup" => ["dup"],
        "drop" => ["drop"],
        "swap" => ["swap"],
        "over" => ["over"],
        "+" => ["+"],
        "-" => ["-"],
        "*" => ["*"],
        "/" => ["/"]
      },
      vals: []
    }
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(%{rules: rules} = ev, s) do
    {rules, vals} =
      s
      |> String.downcase()
      |> separate()
      |> map_integers()
      |> parse(rules)

    vals = calculate(vals, [])

    %{ev | vals: vals ++ ev.vals, rules: rules}
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev), do: ev.vals |> Enum.reverse() |> Enum.join(" ")

  # ============= ============= ============= #

  defp parse(vals, rules), do: do_parse(rules, vals, [])

  defp do_parse(rules, [], parsed), do: {rules, parsed |> Enum.reverse()}

  defp do_parse(rules, [h | t], p) when is_number(h), do: do_parse(rules, t, [h | p])

  defp do_parse(_, [":", rule_name | _], _) when is_number(rule_name),
    do: raise(Forth.InvalidWord)

  defp do_parse(rules, [":", rule_name | t], p) do
    {new_rules, [";" | vals]} = Enum.split_while(t, &(&1 != ";"))

    rules
    |> Map.put(rule_name, new_rules)
    |> do_parse(vals, p)
  end

  defp do_parse(rules, [h | t], p) do
    case rules[h] do
      nil -> raise(Forth.UnknownWord, word: h)
      parsed -> do_parse(rules, t, parsed ++ p)
    end
  end

  defp separate(s), do: s |> String.split(~r/[\x00-\x20\n\r\t\ ]+/)

  defp calculate([], values), do: values

  defp calculate(["dup" | _], []), do: raise(Forth.StackUnderflow)
  defp calculate(["dup" | t], [e | vals]), do: calculate(t, [e, e | vals])

  defp calculate(["drop" | _], []), do: raise(Forth.StackUnderflow)
  defp calculate(["drop" | t], [_ | vals]), do: calculate(t, vals)

  defp calculate(["swap" | _], vals) when length(vals) < 2, do: raise(Forth.StackUnderflow)
  defp calculate(["swap" | t], [a, b | vals]), do: calculate(t, [b, a | vals])

  defp calculate(["over" | _], vals) when length(vals) < 2, do: raise(Forth.StackUnderflow)
  defp calculate(["over" | t], [a, b | vals]), do: calculate(t, [b, a, b | vals])

  defp calculate(["+" | t], vals), do: calculate(t, plus(vals))

  defp calculate(["-" | t], vals), do: calculate(t, sub(vals))

  defp calculate(["*" | t], vals), do: calculate(t, mult(vals))

  defp calculate(["/" | _], [_]), do: raise(Forth.DivisionByZero)
  defp calculate(["/" | t], vals), do: calculate(t, div(vals))

  defp calculate([h | t], vals) when is_number(h), do: calculate(t, [h | vals])

  defp calculate([h | _], _), do: raise(Forth.UnknownWord, word: h)

  defp plus(vals), do: vals |> Enum.reduce(&(&2 + &1)) |> List.wrap()
  defp sub(vals), do: vals |> Enum.reduce(&(&1 - &2)) |> List.wrap()
  defp mult(vals), do: vals |> Enum.reduce(&(&2 * &1)) |> List.wrap()
  defp div(vals), do: [Enum.reduce(vals, 1, fn x, acc -> Integer.floor_div(x, acc) end)]

  defp map_integers(s) do
    Enum.map(s, fn x ->
      cond do
        x =~ ~r/^-?\d+$/ -> String.to_integer(x)
        true -> x
      end
    end)
  end

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
