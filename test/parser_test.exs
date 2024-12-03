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
  
  test "operator +" do
    ast = parse("var = 1 + 2;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:op_add, _,
              {:number, _, 1},
              {:number, _, 2}
             }
            },
            nil} = ast
  end
  
  test "operator -" do
    ast = parse("var = 1 - 2;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:op_sub, _,
              {:number, _, 1},
              {:number, _, 2}
             }
            },
            nil} = ast
  end
  
  test "operator *" do
    ast = parse("var = 1 * 2;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:op_mul, _,
              {:number, _, 1},
              {:number, _, 2}
             }
            },
            nil} = ast
  end
  
  test "operator /" do
    ast = parse("var = 1 / 2;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:op_div, _,
              {:number, _, 1},
              {:number, _, 2}
             }
            },
            nil} = ast
  end
  
  test "operator ==" do
    ast = parse("var = 1 == 2;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:op_eq, _,
              {:number, _, 1},
              {:number, _, 2}
             }
            },
            nil} = ast
  end
  
  test "operator !=" do
    ast = parse("var = 1 != 2;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:op_neq, _,
              {:number, _, 1},
              {:number, _, 2}
             }
            },
            nil} = ast
  end
  
  test "operator <" do
    ast = parse("var = 1 < 2;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:op_lt, _,
              {:number, _, 1},
              {:number, _, 2}
             }
            },
            nil} = ast
  end
  
  test "operator >" do
    ast = parse("var = 1 > 2;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:op_gt, _,
              {:number, _, 1},
              {:number, _, 2}
             }
            },
            nil} = ast
  end
  
  test "operator <=" do
    ast = parse("var = 1 <= 2;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:op_leq, _,
              {:number, _, 1},
              {:number, _, 2}
             }
            },
            nil} = ast
  end
  
  test "operator >=" do
    ast = parse("var = 1 >= 2;")
    
    assert {:stmts, _,
            {:assign, _,
             {:name, _, "var"},
             {:op_geq, _,
              {:number, _, 1},
              {:number, _, 2}
             }
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
  
  test "loop while minimal" do
    ast = parse("while(true);")
    
    assert {:stmts, _,
            {:while, _,
             {:true, _},
             {:empty, _}
            },
            nil} = ast
  end
  
  test "loop while minimal block" do
    ast = parse("while(true){;}")
    
    assert {:stmts, _,
            {:while, _,
             {:true, _},
             {:block, _,
              {:stmts, _,
               {:empty, _},
               nil
              }
             }
            },
            nil} = ast
  end
  
  test "loop while assignment as statement" do
    ast = parse("while(true) v = 42;")
    
    assert {:stmts, _,
            {:while, _,
             {:true, _},
             {:assign, _,
              {:name, _, "v"},
              {:number, _, 42}
             }
            },
            nil} = ast
  end
  
  test "loop while with real condition" do
    ast = parse("while(i==42);")
    
    assert {:stmts, _,
            {:while, _,
             {:op_eq, _,
              {:identifier, _, "i"},
              {:number, _, 42}
             },
             {:empty, _}
            },
            nil} = ast
  end
  
  test "loop for minimal" do
    ast = parse("for(i=1 ; true ; i=1)")
    
    assert {:stmts, _,
            {:for, _,
             {:assign, _,
              {:identifier, _, "i"},
              {:number, _, 1}
             },
             {:true, _},
             {:assign, _,
              {:identifier, _, "i"},
              {:number, _, 1}
             }
            },
            nil} = ast
  end
  
  test "print hello" do
    ast = parse("Console.Write(\"hello\");")
    
    assert {:stmts, _,
            {:print, _,
             {:string, _, "hello"}
            },
            nil} = ast
  end
end
