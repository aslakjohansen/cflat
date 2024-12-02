Nonterminals stmts stmt expr name type.
Terminals '+' '-' '*' '/' '(' ')' '=' ';' '[' ']' number identifier true false if else.
Rootsymbol stmts.

%% operator precedence and associativity
Left 200 '*'.
Left 200 '/'.
Left 100 '+'.
Left 100 '-'.
Left 400 else.

name -> identifier : update_id('$1', name).

type -> identifier : {type, aggregate_location('$1', '$1'), '$1'}.
type -> type '[' ']' : {type, aggregate_location('$1', '$3'), '$1', '$2', '$3'}.

expr -> true : '$1'.
expr -> false : '$1'.
expr -> number : '$1'.
expr -> '(' expr ')' : '$2'.
expr -> expr '*' expr : {op_mul, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr '/' expr : {op_div, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr '+' expr : {op_add, aggregate_location('$1', '$3'), '$1', '$3'}.
expr -> expr '-' expr : {op_sub, aggregate_location('$1', '$3'), '$1', '$3'}.

stmt -> type name '=' expr ';' : {declassign, aggregate_location('$1', '$4'), '$1', '$2', '$4'}.
stmt -> name '=' expr ';' : {assign, aggregate_location('$1', '$4'), '$1', '$3'}.
stmt -> if '(' expr ')' stmt : {branch, aggregate_location('$1', '$5'), '$3', '$5', nil}.
stmt -> if '(' expr ')' stmt else stmt : {branch, aggregate_location('$1', '$7'), '$3', '$5', '$7'}.

%stmts -> stmt stmts : build_sequence(stmts, aggregate_location('$1', '$2'), '$1', '$2').
stmts -> stmt stmts : {stmts, aggregate_location('$1', '$2'), '$1', '$2'}.
%stmts -> stmt : {stmts, aggregate_location('$1', '$1'), ['$1']}.
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
