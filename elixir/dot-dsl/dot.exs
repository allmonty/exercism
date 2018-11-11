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
      %Graph{}
      |> process(code_block)
      |> Macro.escape()

    quote do
      unquote(result)
    end
  end

  defp process(%Graph{} = graph, {{:., _, _}, _, _}) do
    raise ArgumentError
  end

  defp process(%Graph{} = graph, {:__block__, _, []}) do
    graph
  end

  defp process(%Graph{} = graph, {:__block__, _, commands}) do
    commands
    |> Enum.reduce(graph, fn command, graph ->
      process(graph, command)
    end)
  end

  defp process(%Graph{} = graph, {:graph, _, [opts]}) do
    %Graph{graph | attrs: opts ++ graph.attrs}
  end

  defp process(%Graph{} = graph, {:--, _, [_, {{:., _, _}, _, _}]}) do
    raise ArgumentError
  end

  defp process(%Graph{} = graph, {:--, _, [{node_a, _, _}, {node_b, _, [opts]}]}) do
    %Graph{graph | edges: [{node_a, node_b, opts} | graph.edges]}
  end

  defp process(%Graph{} = graph, {:--, _, [{node_a, _, _}, {node_b, _, _}]}) do
    %Graph{graph | edges: [{node_a, node_b, []} | graph.edges]}
  end

  defp process(%Graph{} = graph, {node, _, nil}) do
    %Graph{graph | nodes: [{node, []} | graph.nodes]}
  end

  defp process(%Graph{} = graph, {node, _, [opts]}) do
    %Graph{graph | nodes: [{node, opts} | graph.nodes]}
  end
end
