Definitions.

TRUE       = true
FALSE      = false
IF         = if
ELSE       = else
NUMBER     = [0-9]+
IDENTIFIER = [_a-zAZ][_a-zAZ0-9]*
WHITESPACE = [\s\t\n\r]

Rules.

{TRUE}        : {token, {'true',     produce_position(TokenLine,TokenCol,TokenLen)}}.
{FALSE}       : {token, {'false',    produce_position(TokenLine,TokenCol,TokenLen)}}.
{IF}          : {token, {'if',       produce_position(TokenLine,TokenCol,TokenLen)}}.
{ELSE}        : {token, {'else',     produce_position(TokenLine,TokenCol,TokenLen)}}.
{NUMBER}      : {token, {number,     produce_position(TokenLine,TokenCol,TokenLen), list_to_integer(TokenChars)}}.
{IDENTIFIER}  : {token, {identifier, produce_position(TokenLine,TokenCol,TokenLen), list_to_binary(TokenChars)}}.
\*            : {token, {'*',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\/            : {token, {'/',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\+            : {token, {'+',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\-            : {token, {'-',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\(            : {token, {'(',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\)            : {token, {')',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\=            : {token, {'=',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\;            : {token, {';',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\[            : {token, {'[',    produce_position(TokenLine,TokenCol,TokenLen)}}.
\]            : {token, {']',    produce_position(TokenLine,TokenCol,TokenLen)}}.
{WHITESPACE}+ : skip_token.

Erlang code.

produce_position(Line, Col, Length) ->
    {{Line, Col}, {Line, Col+Length}}
.

%%to_atom([$:|Chars]) ->
%%  list_to_atom(Chars).
