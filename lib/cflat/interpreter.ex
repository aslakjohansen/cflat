defmodule Cflat.Interpreter do
  @moduledoc """
  This module implements an interpreter for syntax trees of code following the grammar of the C♭ programming langauge.
  """
  
  defp eval_expr(state, {:true, _}) do
    {state, true}
  end
  defp eval_expr(state, {:false, _}) do
    {state, false}
  end
  defp eval_expr(state, {:number, _, number}) do
    {state, number}
  end
  defp eval_expr(state, {:identifier, _, name}) do
    {state, Map.get(state, name)}
  end
  defp eval_expr(state, {:op_add, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    {state, lhs_value + rhs_value}
  end
  defp eval_expr(state, {:op_sub, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    {state, lhs_value - rhs_value}
  end
  defp eval_expr(state, {:op_mul, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    {state, lhs_value * rhs_value}
  end
  defp eval_expr(state, {:op_div, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    {state, lhs_value / rhs_value}
  end
  defp eval_expr(state, {:op_eq, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    {state, lhs_value == rhs_value}
  end
  defp eval_expr(state, {:op_neq, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    {state, lhs_value != rhs_value}
  end
  defp eval_expr(state, {:op_lt, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    {state, lhs_value < rhs_value}
  end
  defp eval_expr(state, {:op_gt, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    {state, lhs_value > rhs_value}
  end
  defp eval_expr(state, {:op_leq, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    {state, lhs_value <= rhs_value}
  end
  defp eval_expr(state, {:op_geq, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    {state, lhs_value >= rhs_value}
  end
  defp eval_expr(_state, _) do
    IO.puts("hits eval_expr fallback :-(")
    nil
  end
  
  defp eval_stmt(state, nil) do
    state
  end
  defp eval_stmt(state, {:assign, _, {:name, _, name}, rhs}) do
    {state, value} = eval_expr(state, rhs)
    state |> Map.put(name, value)
  end
  defp eval_stmt(state, {:declassign, _, {:type, _, _type}, {:name, _, name}, rhs}) do
    {state, value} = eval_expr(state, rhs)
    state |> Map.put(name, value)
  end
  defp eval_stmt(state, {:block, _, stmts}) do
    eval_stmts(state, stmts)
  end
  defp eval_stmt(state, {:branch, _, condition, true_stmt, false_stmt}) do
    {state, value} = eval_expr(state, condition)
    if value==true do
      eval_stmt(state, true_stmt)
    else
      eval_stmt(state, false_stmt)
    end
  end
  defp eval_stmt(state, {:while, _, condition, stmt} = full) do
    {state, value} = eval_expr(state, condition)
    if value==true do
      state
      |> eval_stmt(stmt)
      |> eval_stmt(full)
    else
      state
    end
  end
  defp eval_stmt(_state, _stmt) do
    IO.puts("hits eval_stmt fallback :-(")
    nil
  end
  
  defp eval_stmts(state, nil) do
    state
  end
  defp eval_stmts(state, {:stmts, _, head, tail}) do
    state = eval_stmt(state, head)
    eval_stmts(state, tail)
  end
  defp eval_stmts(_state, _stmts) do
    IO.puts("hits eval_stmts fallback :-(")
    nil
  end
  
  @doc """
  Evaluate program in syntax tree form
  
  ## Examples
  
      iex> "int i = 42;" |> Cflat.tokenize() |> Cflat.parse() |> Cflat.Interpreter.evaluate()
      %{"i" => 42}
  
  """
  def evaluate(st) do
    output_state = eval_stmts(%{}, st)
    output_state
  end
end
