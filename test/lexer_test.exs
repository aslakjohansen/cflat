defmodule CflatLexerTest do
  use ExUnit.Case
  
  test "integer value" do
    parts = Cflat.tokenize("42")
    [value] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:number, _, 42} = value
  end
  
  test "true value" do
    parts = Cflat.tokenize("true")
    [value] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:true, _} = value
  end
  
  test "false value" do
    parts = Cflat.tokenize("false")
    [value] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:false, _} = value
  end
  
  test "identifier" do
    parts = Cflat.tokenize("int")
    [identifier] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:identifier, _, "int"} = identifier
  end
  
  test "equals" do
    parts = Cflat.tokenize("=")
    [equals] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:=, _} = equals
  end
  
  test "semicolon" do
    parts = Cflat.tokenize(";")
    [semicolon] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:";", _} = semicolon
  end
  
  test "if" do
    parts = Cflat.tokenize("if")
    [keyword] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:if, _} = keyword
  end
  
  test "else" do
    parts = Cflat.tokenize("else")
    [keyword] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:else, _} = keyword
  end
end
