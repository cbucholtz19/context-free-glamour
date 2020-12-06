%lex

%%

[#][^;]*                    return "COMMENT"
\s+                         return ''
\n                          return ''
\t                          return ''
'('                         return '('
')'                         return ')'
'='                         return '='
"print"                     return "PRINT"
["].*["]                    return "STRING"
[0-9]+("."[0-9]+)?\b        return "NUMBER"
[a-zA-Z|_]([a-zA-Z]|[0-9]|_)*   return "VARIABLE"
';'                         return 'NEWLINE'
.                           return "UNKNOWN_TOKEN"

/lex

%start line

%%

line
    : line VARIABLE '=' e NEWLINE
        {variables[$2] = $4;}
    | line PRINT e NEWLINE
        {pythonOutput($3);}
    | line COMMENT NEWLINE
        {}
    | line NEWLINE
        {}
    |
        {}
    ;

e
    : '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number($1);}
    | VARIABLE
        {$$ = variables[$1];}
    | STRING
        {$$ = $1.slice(1, -1);} //take off the quotes
    ;