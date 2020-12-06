%lex

%%

[#][^;]*                       return "COMMENT"
\s+                            return ''
\n                             return ''
\t                             return ''
"("                            return '('
")"                            return ')'

"<="                           return '<='
">="                           return '>='
"<"                            return '<'
">"                            return '>'
"=="                           return '=='
"!="                           return '!='

"+="                           return '+='
"-="                           return '-='
"**="                          return '**='
"*="                           return '*='
"/="                           return '/='
"%="                           return '%='
"="                            return '='

"+"                            return '+'
"-"                            return '-'
"**"                           return '**'
"*"                            return '*'
"/"                            return '/'
"%"                            return '%'

"True"                         return "TRUE"
"False"                        return "FALSE"

":"                            return ':'
"if"                           return 'IF'
"else"                         return 'ELSE'

"print"                        return "PRINT"
"str"                          return "STR"
"debug_variables"              return "DEBUG_VARIABLES"
["][^"]*["]                    return "STRING"
[0-9]+("."[0-9]+)?\b           return "NUMBER"
[a-zA-Z|_]([a-zA-Z]|[0-9]|_)*  return "VARIABLE"
';'                            return 'NEWLINE'
.                              return "UNKNOWN_TOKEN"

/lex

%left '==' '<=' '>=' '<' '>' '!='
%left '+' '-'
%left '*' '/' '%'
%left '**'

%start line

%%

line
    : line VARIABLE '+=' e NEWLINE
        {variables[$2] += $4}
    | line VARIABLE '-=' e NEWLINE
        {variables[$2] -= $4}
    | line VARIABLE '**=' e NEWLINE
        {variables[$2] **= $4}
    | line VARIABLE '*=' e NEWLINE
        {variables[$2] *= $4}
    | line VARIABLE '/=' e NEWLINE
        {variables[$2] /= $4}
    | line VARIABLE '%=' e NEWLINE
        {variables[$2] %= $4}
    | line VARIABLE '=' e NEWLINE
        {variables[$2] = $4;}

    | line DEBUG_VARIABLES NEWLINE
        {console.dir(variables);}

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
    
    | e '+' e
        {$$ = $1 + $3}
    | e '-' e
        {$$ = $1 - $3}
    | e '**' e
        {$$ = $1 ** $3}
    | e '*' e
        {$$ = $1 * $3}
    | e '/' e
        {$$ = $1 / $3}
    | e '%' e
        {$$ = $1 % $3}

    | e '<=' e
        {$$ = $1 <= $3}
    | e '>=' e
        {$$ = $1 >= $3}
    | e '<' e
        {$$ = $1 < $3}
    | e '>' e
        {$$ = $1 > $3}
    | e '==' e
        {$$ = $1 == $3}
    | e '!=' e
        {$$ = $1 != $3}

    | NUMBER
        {$$ = Number($1);} //parse string to number
    | VARIABLE
        {$$ = variables[$1];}
    | STRING
        {$$ = $1.slice(1, -1);} //take off the quotes
    
    | TRUE
        {$$ = true}
    | FALSE
        {$$ = false}
    
    | STR '(' e ')'
        {$$ = $3}
    ;