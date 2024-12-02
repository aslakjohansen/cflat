defmodule Cflat do
  @moduledoc """
  Documentation for `Cflat` (C♭), a programming language with a striking resemblance to C# (without objects).
  
  **Note:** This is very early in the development.
  """
  
  @doc """
  Perform lexical analysis on text in order to produce a list of tokens.
  
  ## Examples
  
      iex> Cflat.tokenize("int i = 42;")
      [
        {:identifier, {{1, 1}, {1, 4}}, "int"},
        {:identifier, {{1, 5}, {1, 6}}, "i"},
        {:=, {{1, 7}, {1, 8}}},
        {:number, {{1, 9}, {1, 11}}, 42},
        {:";", {{1, 11}, {1, 12}}}
      ]
  
  """
  def tokenize(text) when is_binary(text) do
    {:ok, tokens, _} = text |> to_charlist() |> :lexer.string()
    tokens
  end
  
  @doc """
  Parse list of tokens into an abstract syntax tree.
  
  ## Examples
  
      iex> "int i = 42;" |> Cflat.tokenize() |> Cflat.parse()
      {:stmts, {{1, 1}, {1, 11}},
       {:declassign, {{1, 1}, {1, 11}},
        {:type, {{1, 1}, {1, 4}}, {:identifier, {{1, 1}, {1, 4}}, "int"}},
        {:name, {{1, 5}, {1, 6}}, "i"}, {:number, {{1, 9}, {1, 11}}, 42}}, nil}
  
  """
  def parse(tokens) do
    {:ok, ast} = :parser.parse(tokens)
    ast
  end
end
