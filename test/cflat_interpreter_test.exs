defmodule CflatInterpreterTest do
  use ExUnit.Case
  doctest Cflat.Interpreter
  
  defp evaluate(code) do
    code
    |> Cflat.tokenize()
    |> Cflat.parse()
    |> Cflat.Interpreter.evaluate()
  end
  
  defp env_assert(result, correct) do
    assert is_map(result)
    assert result == correct
  end
  
  test "assignment" do
    env = evaluate("int v = 42;")
    
    env_assert(env, %{"v" => 42})
  end
  
  test "double assign" do
    env = evaluate("int v1 = 42; int v2 = 56;")
    
    env_assert(env, %{"v1" => 42, "v2" => 56})
  end
  
  test "branch when true" do
    env = evaluate("int v = 0; if (true) v=1;")
    
    env_assert(env, %{"v" => 1})
  end
  
  test "branch when false without else" do
    env = evaluate("int v = 0; if (false) v=1;")
    
    env_assert(env, %{"v" => 0})
  end
  
  test "branch when false with else" do
    env = evaluate("int v = 0; if (false) v=1; else v=2;")
    
    env_assert(env, %{"v" => 2})
  end
end
