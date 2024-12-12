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
  defp eval_expr(state, {:string, _, value}) do
    {state, value}
  end
  defp eval_expr(state, {:identifier, _, name}) do
    {state, Map.get(state, name)}
  end
  defp eval_expr(state, {:op_add, _, lhs_expr, rhs_expr}) do
    {state, lhs_value} = eval_expr(state, lhs_expr)
    {state, rhs_value} = eval_expr(state, rhs_expr)
    result = cond do
      is_integer(lhs_value) and is_integer(rhs_value) -> lhs_value + rhs_value
      is_binary(lhs_value) -> "#{lhs_value}#{rhs_value}"
      is_binary(rhs_value) -> "#{lhs_value}#{rhs_value}"
    end
    {state, result}
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
  
  defp eval_stmt_simple(state, nil) do
    state
  end
  defp eval_stmt_simple(state, {:assign, _, {:name, _, name}, rhs}) do
    {state, value} = eval_expr(state, rhs)
    state |> Map.put(name, value)
  end
  defp eval_stmt_simple(state, {:declassign, _, {:type, _, _type}, {:name, _, name}, rhs}) do
    {state, value} = eval_expr(state, rhs)
    state |> Map.put(name, value)
  end
  defp eval_stmt_simple(state, {:print, _, expr}) do
    {state, value} = eval_expr(state, expr)
    IO.write(value)
    state
  end
  defp eval_stmt_simple(state, {:println, _, expr}) do
    {state, value} = eval_expr(state, expr)
    IO.puts(value)
    state
  end
  defp eval_stmt_simple(_state, stmt) do
    IO.puts("hits eval_stmt_simple fallback :-(")
    IO.puts("offending statement: #{stmt}")
    nil
  end
  
  defp eval_stmt_complex(state, {:block, _, stmts}) do
    eval_stmts(state, stmts)
  end
  defp eval_stmt_complex(state, {:branch, _, condition, true_stmt, false_stmt}) do
    {state, value} = eval_expr(state, condition)
    if value==true do
      eval_stmt(state, true_stmt)
    else
      eval_stmt(state, false_stmt)
    end
  end
  defp eval_stmt_complex(state, {:while, _, condition, stmt} = full) do
    {state, value} = eval_expr(state, condition)
    if value==true do
      state
      |> eval_stmt(stmt)
      |> eval_stmt_complex(full)
    else
      state
    end
  end
  defp eval_stmt_complex(state, {:do_while, _, stmt, condition} = full) do
    state = eval_stmt(state, stmt)
    {state, value} = eval_expr(state, condition)
    if value==true do
      eval_stmt_complex(state, full)
    else
      state
    end
  end
  defp eval_stmt_complex(state, {:for, _, nil, condition, stmt_update, stmt_body} = full) do
    {state, value} = eval_expr(state, condition)
    if value==true do
      state
      |> eval_stmt(stmt_body)
      |> eval_stmt_simple(stmt_update)
      |> eval_stmt_complex(full)
    else
      state
    end
  end
  defp eval_stmt_complex(state, {:for, location, stmt_init, condition, stmt_update, stmt_body}) do
    state
    |> eval_stmt_simple(stmt_init)
    |> eval_stmt_complex({:for, location, nil, condition, stmt_update, stmt_body})
  end
  defp eval_stmt_complex(_state, stmt) do
    IO.puts("hits eval_stmt_complex fallback :-(")
    IO.puts("offending statement: #{stmt}")
    nil
  end
  
  defp eval_stmt(state, {:stmt_nil} = _stmt) do
    state
  end
  defp eval_stmt(state, nil = _stmt) do
    state
  end
  defp eval_stmt(state, {:stmt_simple, _, stmt} = _outer_stmt) do
    eval_stmt_simple(state, stmt)
  end
  defp eval_stmt(state, {:stmt_complex, _, stmt} = _outer_stmt) do
    eval_stmt_complex(state, stmt)
  end
  defp eval_stmt(_state, stmt) do
    IO.puts("hits eval_stmt fallback :-(")
    IO.puts("offending statement: #{stmt}")
    nil
  end
  
  defp eval_stmts(state, nil) do
    state
  end
  defp eval_stmts(state, {:stmts, _, head, nil}) do
    _state = eval_stmt(state, head)
  end
  defp eval_stmts(state, {:stmts, _, head, tail}) do
    state = eval_stmt(state, head)
    eval_stmts(state, tail)
  end
  defp eval_stmts(_state, stmts) do
    IO.puts("hits eval_stmts fallback :-(")
    IO.puts("offending statement: #{stmts}")
    nil
  end
  
  @doc """
  Evaluate program in syntax tree form
  
  ## Examples
  
      iex> "int i = 42;" |> Cflat.tokenize() |> Cflat.parse() |> Cflat.Interpreter.evaluate()
      %{"i" => 42}
  
  """
  
  def evaluate(st) do
    evaluate(st, %{})
  end
  
  @doc """
  Evaluate program in syntax tree form in environment
  
  ## Examples
  
      iex> "int i = j + 1;" |> Cflat.tokenize() |> Cflat.parse() |> Cflat.Interpreter.evaluate(%{"j" => 42})
      %{"i" => 43, "j" => 42}
  
  """
  def evaluate(st, env) when is_map(env) do
    output_state = eval_stmts(env, st)
    output_state
  end
end
