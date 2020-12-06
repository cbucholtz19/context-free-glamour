%lex

%s COMMENT

%%

"#"                         { this.begin('COMMENT') }
<COMMENT>\n                 { this.begin('INITIAL') }
<COMMENT>.                  { ; }

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
[0-9]+("."[0-9]+)?\b        return 'NUMBER'
[a-zA-Z]([a-zA-Z]|[0-9])*   return 'VARIABLE'

/lex

%start line

%%

line
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
        {pythonOutput($3);}
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
    ;