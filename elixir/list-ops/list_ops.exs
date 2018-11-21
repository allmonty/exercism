defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count([]), do: 0
  def count([_ | t]), do: 1 + count(t)

  @spec reverse(list) :: list
  def reverse(l), do: do_reverse(l, [])
  defp do_reverse([], rl), do: rl
  defp do_reverse([h | t], rl), do: do_reverse(t, [h | rl])

  @spec map(list, (any -> any)) :: list
  def map([], _f), do: []
  def map([h | t], f), do: [f.(h) | map(t, f)]

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], _f), do: []
  def filter([h | t], f), do: if(f.(h), do: [h | filter(t, f)], else: filter(t, f))

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _f), do: acc
  def reduce([h | t], acc, f), do: reduce(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append(a, b), do: reduce(reverse(a), b, &[&1 | &2])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: reduce(reverse(ll), [], &append(&1, &2))
end
