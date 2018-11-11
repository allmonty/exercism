defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []

  def add_node(%Graph{nodes: nodes} = graph, node) do
    %Graph{graph | nodes: [node | nodes]}
  end

  def add_edge(%Graph{edges: edges} = graph, edge) do
    %Graph{graph | edges: [edge | edges]}
  end

  def add_attr(%Graph{attrs: attrs} = graph, attr) do
    %Graph{graph | attrs: attr ++ attrs}
  end
end

defmodule Dot do
  defmacro graph(do: code_block) do
    result =
      %Graph{}
      |> process(code_block)
      |> Macro.escape()

    quote do: unquote(result)
  end

  defp process(%Graph{} = graph, {:__block__, _, []}), do: graph

  defp process(%Graph{} = graph, {:__block__, _, commands}) do
    commands
    |> Enum.reduce(graph, fn command, graph -> process(graph, command) end)
  end

  defp process(%Graph{} = graph, {:graph, _, [opts]}) do
    Graph.add_attr(graph, opts)
  end

  defp process(%Graph{}, {:--, _, [_, {{:., _, _}, _, _}]}), do: raise(ArgumentError)

  defp process(%Graph{} = graph, {:--, _, [{node_a, _, _}, {node_b, _, [opts]}]}) do
    Graph.add_edge(graph, {node_a, node_b, opts})
  end

  defp process(%Graph{} = graph, {:--, _, [{node_a, _, _}, {node_b, _, _}]}) do
    Graph.add_edge(graph, {node_a, node_b, []})
  end

  defp process(%Graph{}, {_, _, [{{:., _, _}, _, _}]}), do: raise(ArgumentError)

  defp process(%Graph{} = graph, {node, _, nil}) do
    Graph.add_node(graph, {node, []})
  end

  defp process(%Graph{} = graph, {node, _, [opts]}) do
    case Keyword.keyword?(opts) do
      true -> Graph.add_node(graph, {node, opts})
      false -> raise ArgumentError
    end
  end

  defp process(_, _), do: raise(ArgumentError)
end
