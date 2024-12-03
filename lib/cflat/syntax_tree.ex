defmodule Cflat.SyntaxTree do
  @moduledoc """
  This module provides functionality for rendering of abstract syntax trees.
  """
  
  defp type2class(:stmts), do: "stmts"
  defp type2class(:stmt), do: "stmt"
  defp type2class(:declassign), do: "expr"
  defp type2class(:type), do: "expr"
  defp type2class(:identifier), do: "expr"
  defp type2class(:number), do: "value"
  defp type2class(:true), do: "value"
  defp type2class(:false), do: "value"
  defp type2class(:name), do: "expr"
  defp type2class(:op_add), do: "operator"
  defp type2class(:op_sub), do: "operator"
  defp type2class(:op_mul), do: "operator"
  defp type2class(:op_div), do: "operator"
  defp type2class(:op_eq), do: "operator"
  defp type2class(:op_neq), do: "operator"
  defp type2class(:op_lt), do: "operator"
  defp type2class(:op_gt), do: "operator"
  defp type2class(:op_leq), do: "operator"
  defp type2class(:op_geq), do: "operator"
  defp type2class(:op_if), do: "keyword"
  defp type2class(:op_for), do: "keyword"
  defp type2class(_), do: "unknown"
  
  defp process_subtree(subtree, lines, parent, next_id) when is_tuple(subtree) do
    [type|[_location|children]] = Tuple.to_list(subtree)
    node_id = "node#{next_id}"
    
    lines =
      (
        """
          #{node_id}[#{type}]
          class #{node_id} #{type2class(type)}
          #{
            if parent != nil do
              "#{parent} --> #{node_id}"
            else
              ""
            end
          }
        """
        |> String.split("\n")
        |> Enum.filter(fn line -> String.trim(line) != "" end)
        |> Enum.reverse()
      )++lines
    
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
      (
        """
          #{node_id}[#{value}]
          class #{node_id} #{if subtree==nil do "nil" else "leaf" end}
          #{parent} --> #{node_id}
        """
        |> String.split("\n")
        |> Enum.filter(fn line -> line != "" end)
        |> Enum.reverse()
      )++lines,
      next_id+1
    }
  end
  
  @doc """
  Produce [Mermaid](https://mermaid.js.org) code for illustrating syntax trees.
  
  ## Examples
  
      iex> "int i = 42;" |> Cflat.tokenize() |> Cflat.parse() |> Cflat.SyntaxTree.as_mermaid()
  
  """
  def as_mermaid(st) do
    lines =
      """
      flowchart
        classDef nil      stroke:8e032e,fill:#8e032e,color:#ffffff
        classDef stmts    stroke:03868e,fill:#03868e,color:#ffffff
        classDef stmt     stroke:03208e,fill:#03208e,color:#ffffff
        classDef expr     stroke:8e6e03,fill:#8e6e03,color:#ffffff
        classDef operator stroke:8e6e03,fill:#8e6e03,color:#ffffff
        classDef leaf     stroke:788e03,fill:#788e03,color:#ffffff
        classDef value    stroke:788e03,fill:#788e03,color:#ffffff
        classDef keyword  stroke:000000,fill:#000000,color:#ffffff
        classDef unknown  stroke:ff0000,fill:#000000,color:#ffffff
        
      """
      |> String.split("\n")
      |> Enum.filter(fn line -> line != "" end)
      |> Enum.reverse()
    process_subtree(st, lines, nil, 0)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join("\n")
  end
end
