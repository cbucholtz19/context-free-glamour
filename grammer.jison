%lex

<<<<<<< HEAD
%s COMMENT

%%

"#"                         { this.begin('COMMENT') }
<COMMENT>\n                 { this.begin('INITIAL') }
<COMMENT>.                  { ; }

=======
%%

[#][^;]*                    return "COMMENT"
>>>>>>> ab6af39fc996d32193a88c254c283423c4949986
\s+                         return ''
\n                          return ''
\t                          return ''
"("                         return '('
")"                         return ')'

"<="                        return '<='
">="                        return '>='
"<"                         return '<'
">"                         return '>'
"=="                        return '=='
"!="                        return '!='

"+="                        return '+='
"-="                        return '-='
"**="                       return '**='
"*="                        return '*='
"/="                        return '/='
"%="                        return '%='
"="                         return '='

"+"                         return '+'
"-"                         return '-'
"**"                        return '^'
"*"                         return '*'
"/"                         return '/'
"%"                         return '%'

":"                         return ':'
"if"                        return 'if'
"else"                      return 'else'

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
<<<<<<< HEAD
    : line VARIABLE '+=' e
        {variables[$2] += $4}
    | line VARIABLE '-=' e
        {variables[$2] -= $4}
    | line VARIABLE '**=' e
        {variables[$2] **= $4}
    | line VARIABLE '*=' e
        {variables[$2] *= $4}
    | line VARIABLE '/=' e
        {variables[$2] /= $4}
    | line VARIABLE '%=' e
        {variables[$2] %= $4}
    | line VARIABLE '=' e
        {variables[$2] = $4;}

    | line PRINT e
=======
    : line VARIABLE '=' e NEWLINE
        {variables[$2] = $4;}
    | line PRINT e NEWLINE
>>>>>>> ab6af39fc996d32193a88c254c283423c4949986
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
        {$$ = Number($1);}
    | VARIABLE
        {$$ = variables[$1];}
    | STRING
        {$$ = $1.slice(1, -1);} //take off the quotes
    ;