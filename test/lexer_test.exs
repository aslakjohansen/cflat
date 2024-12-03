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
  
  test "operator eq" do
    parts = Cflat.tokenize("==")
    [value] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:eq, _} = value
  end
  
  test "operator neq" do
    parts = Cflat.tokenize("!=")
    [value] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:neq, _} = value
  end
  
  test "operator lt" do
    parts = Cflat.tokenize("<")
    [value] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:lt, _} = value
  end
  
  test "operator gt" do
    parts = Cflat.tokenize(">")
    [value] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:gt, _} = value
  end
  
  test "operator leq" do
    parts = Cflat.tokenize("<=")
    [value] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:leq, _} = value
  end
  
  test "operator geq" do
    parts = Cflat.tokenize(">=")
    [value] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:geq, _} = value
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
  
  test "while" do
    parts = Cflat.tokenize("while")
    [keyword] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:while, _} = keyword
  end
  
  test "do" do
    parts = Cflat.tokenize("do")
    [keyword] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:do, _} = keyword
  end
  
  test "for" do
    parts = Cflat.tokenize("for")
    [keyword] = parts
    
    assert is_list(parts)
    assert length(parts) == 1
    assert {:for, _} = keyword
  end
end
