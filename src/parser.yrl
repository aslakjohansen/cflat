Nonterminals stmts stmt expr name type.
Terminals '+' '-' '*' '/' '(' ')' '=' ';' '[' ']' '{' '}' eq neq lt gt leq geq string number identifier true false if else while do for print println.
Rootsymbol stmts.

%% operator precedence and associativity
Left 300 ';'.
Left 200 '*'.
Left 200 '/'.
Left 100 '+'.
Left 100 '-'.
Left  50 eq.
Left  50 neq.
Left  50 lt.
Left  50 gt.
Left  50 leq.
Left  50 geq.
Left 400 else.

name -> identifier : update_id('$1', name).

type -> identifier : {type, aggregate_location('$1', '$1'), '$1'}.
type -> type '[' ']' : {type, aggregate_location('$1', '$3'), '$1', '$2', '$3'}.

expr -> true : '$1'.
expr -> false : '$1'.
expr -> string : '$1'.
expr -> number : '$1'.
expr -> identifier : '$1'.
expr -> '(' expr ')' : '$2'.
expr -> expr '*' expr : {op_mul, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr '/' expr : {op_div, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr '+' expr : {op_add, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr '-' expr : {op_sub, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr eq expr  : {op_eq, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr neq expr : {op_neq, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr lt expr  : {op_lt, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr gt expr  : {op_gt, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr leq expr : {op_leq, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr geq expr : {op_geq, aggregate_location('$1', '$3'), '$1', '$3'}.

stmt -> ';' : {empty, aggregate_location('$1', '$1')}.
stmt -> type name '=' expr ';' : {declassign, aggregate_location('$1', '$4'), '$1', '$2', '$4'}.
stmt -> name '=' expr ';' : {assign, aggregate_location('$1', '$4'), '$1', '$3'}.
stmt -> if '(' expr ')' stmt : {branch, aggregate_location('$1', '$5'), '$3', '$5', nil}.
stmt -> if '(' expr ')' stmt else stmt : {branch, aggregate_location('$1', '$7'), '$3', '$5', '$7'}.
stmt -> while '(' expr ')' stmt : {while, aggregate_location('$1', '$5'), '$3', '$5'}.
stmt -> do stmt while '(' expr ')' : {do_while, aggregate_location('$1', '$6'), '$2', '$5'}.
stmt -> for '(' stmt ';' expr ';' stmt ')' stmt : {for, aggregate_location('$1', '$9'), '$3', '$5', '$7', '$9'}.
stmt -> print '(' expr ')' ';' : {print, aggregate_location('$1', '$5'), '$3'}.
stmt -> println '(' expr ')' ';' : {println, aggregate_location('$1', '$5'), '$3'}.
stmt -> '{' stmts '}' : {block, aggregate_location('$1', '$3'), '$2'}.

stmts -> stmt stmts : {stmts, aggregate_location('$1', '$2'), '$1', '$2'}.
stmts -> stmt : {stmts, aggregate_location('$1', '$1'), '$1', nil}.

Erlang code.

%%extract_token({_Token, _Line, Value}) -> Value.

aggregate_location(LocationA, LocationB) ->
  {BeginA,_EndA} = element(2, LocationA),
  {_BeginB,EndB} = element(2, LocationB),
  {
    BeginA,
    EndB
  }
.

%build_sequence(Name, Location, Hd, Tl) ->
%  {
%    Name,
%    Location,
%    [Hd|Tl]
%  }
%.

update_id(OriginalTuple, NewId) ->
  setelement(1, OriginalTuple, NewId)
  .
