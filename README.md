# Cflat

This package implements the C♭ langauge (pronounced C-flat). It aims to implement the procedural subset of C#.

Currently, it supports:
- integers and booleans.
- variable declarations and assignments in one statement.
- variable assignments
- branches with `if` ad `else`.
- blocks.
- while and do-while loops.

Functionality implemented:
- Lexing
- Parsing
- Rendering of abstract syntax tree
- Evaluation of abstract syntax tree (result as a map of variables)

## Installation

The package can be installed by adding `cflat` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cflat, "~> 0.2.0"}
  ]
end
```
The docs can be found at <https://hexdocs.pm/cflat>.
