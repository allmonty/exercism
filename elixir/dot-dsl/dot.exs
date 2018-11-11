defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []
end

defmodule Dot do
  defmacro graph(do: code_block) do
    IO.inspect(code_block, label: "\ncode_block")

    nodes =
      case code_block do
        {:__block__, _, _} -> []
        {node, _, nil} -> [{node, []}]
        {node, _, [opts]} -> [{node, opts}]
      end

    quote do
      %Graph{nodes: unquote(nodes)}
    end
  end
end
