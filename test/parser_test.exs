defmodule CflatParserTest do
  use ExUnit.Case
  
  defp parse(code) do
    code
    |> Cflat.tokenize()
    |> Cflat.parse()
  end
  
  test "empty statement" do
    ast = parse(";")
    
    assert {:stmts, _,
            {:empty, _},
            nil} = ast
  end
  
  test "declaration assignment" do
    ast = parse("var = 42;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:number, _, 42}
            },
            nil} = ast
  end
  
  test "branch minimal without else" do
    ast = parse("if(true);")
    
    assert {:stmts, _,
            {:branch, _,
             {:true, _},
             {:empty, _},
             nil
            },
            nil} = ast
  end
  
  test "branch minimal with else" do
    ast = parse("if(true);else;")
    
    assert {:stmts, _,
            {:branch, _,
             {:true, _},
             {:empty, _},
             {:empty, _}
            },
            nil} = ast
  end
  
  test "block empty" do
    ast = parse("{;}")
    
    assert {:stmts, _,
            {:block, _,
             {:stmts, _, {:empty, _}, nil}
            },
            nil} = ast
  end
  
  test "branch minimal block without else" do
    ast = parse("if(true){;}")
    
    assert {:stmts, _,
            {:branch, _,
             {:true, _},
             {:block, _,
              {:stmts, _,
               {:empty, _},
               nil
              }
             },
             nil
            },
            nil} = ast
  end
  
  test "branch minimal block with else" do
    ast = parse("if(true){;}else{;}")
    
    assert {:stmts, _,
            {:branch, _,
             {:true, _},
             {:block, _,
              {:stmts, _,
               {:empty, _},
               nil
              }
             },
             {:block, _,
              {:stmts, _,
               {:empty, _},
               nil
              }
             }
            },
            nil} = ast
  end
end
