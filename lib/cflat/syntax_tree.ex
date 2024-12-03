defmodule Cflat.SyntaxTree do
  @moduledoc """
  This module provides functionality for rendering of abstract syntax trees.
  """
  
  defp process_subtree(subtree, lines, parent, next_id) when is_tuple(subtree) do
    [type|[_location|children]] = Tuple.to_list(subtree)
    node_id = "node#{next_id}"
    
    nodedef_line = "  #{node_id}[#{type}]"
    lines = case parent do
      nil -> [nodedef_line|lines]
      _ -> ["  #{parent} --> #{node_id}"|[nodedef_line|lines]]
    end
    
    children
    |> Enum.reduce({lines, next_id}, fn child, {lines, next_id} ->
        process_subtree(child, lines, node_id, next_id+1)
      end
    )
  end
  
  defp process_subtree(subtree, lines, parent, next_id) do
    value = if subtree==nil do "nil" else subtree end
    node_id = "node#{next_id}"
    
    {
      ["  #{parent} --> #{node_id}"|["  #{node_id}[#{value}]"|lines]],
      next_id+1
    }
  end
  
  @doc """
  Produce [Mermaid](https://mermaid.js.org) code for illustrating syntax trees.
  
  ## Examples
  
      iex> "int i = 42;" |> Cflat.tokenize() |> Cflat.parse() |> Cflat.SyntaxTree.as_mermaid()
  
  """
  def as_mermaid(st) do
    process_subtree(st, ["flowchart"], nil, 0)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join("\n")
  end
end
