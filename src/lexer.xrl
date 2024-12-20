Definitions.

TRUE       = true
FALSE      = false
IF         = if
ELSE       = else
WHILE      = while
DO         = do
FOR        = for
PRINT      = Console.Write
PRINTLN    = Console.WriteLine
STRING     = \"(\\.|[^"\\])*\"
NUMBER     = [0-9]+
IDENTIFIER = [_a-zAZ][_a-zAZ0-9]*
WHITESPACE = [\s\t\n\r]
EQ         = \=\=
NEQ        = \!\=
LT         = \<
GT         = \>
LEQ        = \<\=
GEQ        = \>\=

Rules.

{TRUE}        : {token, {'true',     produce_position(TokenLine,TokenCol,TokenLen)}}.
{FALSE}       : {token, {'false',    produce_position(TokenLine,TokenCol,TokenLen)}}.
{IF}          : {token, {'if',       produce_position(TokenLine,TokenCol,TokenLen)}}.
{ELSE}        : {token, {'else',     produce_position(TokenLine,TokenCol,TokenLen)}}.
{WHILE}       : {token, {'while',    produce_position(TokenLine,TokenCol,TokenLen)}}.
{DO}          : {token, {'do',       produce_position(TokenLine,TokenCol,TokenLen)}}.
{FOR}         : {token, {'for',      produce_position(TokenLine,TokenCol,TokenLen)}}.
{PRINT}       : {token, {'print',    produce_position(TokenLine,TokenCol,TokenLen)}}.
{PRINTLN}     : {token, {'println',  produce_position(TokenLine,TokenCol,TokenLen)}}.
{STRING}      : {token, {string,     produce_position(TokenLine,TokenCol,TokenLen), list_to_binary(lists:sublist(TokenChars, 2, length(TokenChars) - 2))}}.
{NUMBER}      : {token, {number,     produce_position(TokenLine,TokenCol,TokenLen), list_to_integer(TokenChars)}}.
{IDENTIFIER}  : {token, {identifier, produce_position(TokenLine,TokenCol,TokenLen), list_to_binary(TokenChars)}}.
\*            : {token, {'*',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\/            : {token, {'/',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\+            : {token, {'+',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\-            : {token, {'-',    produce_position(TokenLine,TokenCol,TokenLen)}}.
{EQ}          : {token, {'eq',   produce_position(TokenLine,TokenCol,TokenLen)}}.
{NEQ}         : {token, {'neq',  produce_position(TokenLine,TokenCol,TokenLen)}}.
{LT}          : {token, {'lt',   produce_position(TokenLine,TokenCol,TokenLen)}}.
{GT}          : {token, {'gt',   produce_position(TokenLine,TokenCol,TokenLen)}}.
{LEQ}         : {token, {'leq',  produce_position(TokenLine,TokenCol,TokenLen)}}.
{GEQ}         : {token, {'geq',  produce_position(TokenLine,TokenCol,TokenLen)}}.
\(            : {token, {'(',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\)            : {token, {')',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\=            : {token, {'=',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\;            : {token, {';',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\[            : {token, {'[',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\]            : {token, {']',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\{            : {token, {'{',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\}            : {token, {'}',    produce_position(TokenLine,TokenCol,TokenLen)}}.
{WHITESPACE}+ : skip_token.

Erlang code.

produce_position(Line, Col, Length) ->
    {{Line, Col}, {Line, Col+Length}}
.

%%to_atom([$:|Chars]) ->
%%  list_to_atom(Chars).
