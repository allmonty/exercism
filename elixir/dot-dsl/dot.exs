defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []

  def add_node(%Graph{nodes: nodes} = graph, node) do
    %Graph{graph | nodes: [node | nodes]}
  end
end

defmodule Dot do
  defmacro graph(do: code_block) do
    IO.inspect(code_block, label: "\ncode_block")

    result =
      code_block
      |> process()
      |> Macro.escape()

    quote do
      unquote(result)
    end
  end

  defp process({:__block__, _, []}), do: %Graph{}

  defp process({:--, _, [{node_a, _, _}, {node_b, _, _}]}),
    do: %Graph{edges: [{node_a, node_b, []}]}

  defp process({node, _, nil}), do: %Graph{nodes: [{node, []}]}
  defp process({node, _, [opts]}), do: %Graph{nodes: [{node, opts}]}
end
