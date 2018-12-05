defmodule BinTree do
  import Inspect.Algebra

  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{value: any, left: BinTree.t() | nil, right: BinTree.t() | nil}
  defstruct value: nil, left: nil, right: nil

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BT[value: 3, left: BT[value: 5, right: BT[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: v, left: l, right: r}, opts) do
    concat([
      "(",
      to_doc(v, opts),
      ":",
      if(l, do: to_doc(l, opts), else: ""),
      ":",
      if(r, do: to_doc(r, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  alias BinTree, as: BT
  alias __MODULE__, as: Z

  @type t :: %Z{stack: list, node: BT.t() | nil, tree: BT.t() | nil}
  defstruct stack: [], node: nil, tree: nil

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t()) :: Z.t()
  def from_tree(bt), do: %Z{node: bt, tree: bt}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t()) :: BT.t()
  def to_tree(z), do: z.tree

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t()) :: any
  def value(z), do: z.node.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t()) :: Z.t() | nil
  def left(%Z{node: %BT{left: nil}}), do: nil
  def left(z), do: %Z{z | stack: [:left | z.stack], node: z.node.left}

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t()) :: Z.t() | nil
  def right(%Z{node: %BT{right: nil}}), do: nil
  def right(z), do: %Z{z | stack: [:right | z.stack], node: z.node.right}

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t()) :: Z.t()
  def up(%Z{stack: []}), do: nil

  def up(%Z{stack: [_ | t]} = z) do
    new_node = t |> Enum.reverse() |> follow_stack(z.tree)
    %Z{z | stack: t, node: new_node}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t(), any) :: Z.t()
  def set_value(z, v) do
    new_node = %BT{z.node | value: v}
    new_tree = z.stack |> Enum.reverse() |> update_node(z.tree, new_node)
    %Z{z | node: new_node, tree: new_tree}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t(), BT.t()) :: Z.t()
  def set_left(z, l) do
    new_node = %BT{z.node | left: l}
    new_tree = z.stack |> Enum.reverse() |> update_node(z.tree, new_node)
    %Z{z | node: new_node, tree: new_tree}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t(), BT.t()) :: Z.t()
  def set_right(z, r) do
    new_node = %BT{z.node | right: r}
    new_tree = z.stack |> Enum.reverse() |> update_node(z.tree, new_node)
    %Z{z | node: new_node, tree: new_tree}
  end

  defp follow_stack(stack, tree) do
    Enum.reduce(stack, tree, fn dir, tree -> Map.fetch!(tree, dir) end)
  end

  defp update_node([], _, new), do: new

  defp update_node([h | t], current, new) do
    next_node = Map.fetch!(current, h)
    Map.put(current, h, update_node(t, next_node, new))
  end
end
