%lex

%%

[#][^(\r\n|\r|\n)]*                       return "COMMENT"
[\r\n|\r|\n]                   return "NEWLINE"
\s+                            return ''
\t                             return ''
"("                            return '('
")"                            return ')'
"{"                            return "{"
"}"                            return "}"

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
"debug"                        return "DEBUG"
"debug_variables"              return "DEBUG_VARIABLES"
["][^"]*["]                    return "STRING"
[0-9]+("."[0-9]+)?\b           return "NUMBER"
[a-zA-Z|_]([a-zA-Z]|[0-9]|_)*  return "VARIABLE"
// ';'                            return 'NEWLINE'
<<EOF>>                        return "EOF"
.                              return "UNKNOWN_TOKEN"

/lex

%left '==' '<=' '>=' '<' '>' '!='
%left '+' '-'
%left '*' '/' '%'
%left '**'

%start program

%%

program
    : line
        {return $line}
    ;

line
    // : line VARIABLE '+=' e lineend
    //     {variables[$2] += $4}
    // | line VARIABLE '-=' e lineend
    //     {variables[$2] -= $4}
    // | line VARIABLE '**=' e lineend
    //     {variables[$2] **= $4}
    // | line VARIABLE '*=' e lineend
    //     {variables[$2] *= $4}
    // | line VARIABLE '/=' e lineend
    //     {variables[$2] /= $4}
    // | line VARIABLE '%=' e lineend
    //     {variables[$2] %= $4}
    // : line VARIABLE '=' e lineend
    //     {$$ = {next : [null, null], action : ["set_variable", $e]}}

    // | line DEBUG_VARIABLES lineend
    //     {console.dir(variables);}

    : PRINT '(' e ')' lineend line
        {$$ = {next : $line, action : ["print", $e]}}
    
    | IF e '{' line '}' ELSE '{' line '}' lineend line
        {$$ = {next : $11, action : ["if", $e, $4, $8]}}

    // | line DEBUG lineend
    //     {$$ = {next : [$1, null], action : ["debug"]}}

    // | line COMMENT lineend
    //     {}
    | lineend line
        {$$ = {next : $line, action : ["no_op"]}}
    |
        {$$ = {next : null, action : ["no_op"]}}
    ;

lineend
    : NEWLINE
        {}
    | EOF
        {}
    ;

e
    // : '(' e ')'
    //     {$$ = $2;}
    
    // | e '+' e
    //     {$$ = ["+", $1, $3]}
    // | e '-' e
    //     {$$ = $1 - $3}
    // | e '**' e
    //     {$$ = $1 ** $3}
    // | e '*' e
    //     {$$ = $1 * $3}
    // | e '/' e
    //     {$$ = $1 / $3}
    // | e '%' e
    //     {$$ = $1 % $3}

    // | e '<=' e
    //     {$$ = $1 <= $3}
    // | e '>=' e
    //     {$$ = $1 >= $3}
    // | e '<' e
    //     {$$ = $1 < $3}
    // | e '>' e
    //     {$$ = $1 > $3}
    // | e '==' e
    //     {$$ = $1 == $3}
    // | e '!=' e
    //     {$$ = $1 != $3}

    : NUMBER
        {$$ = {next : null, action : ["number", Number($1)]}} //parse string to number
    // | VARIABLE
    //     {$$ = {next : null, action : ["variable", $VARIABLE]}}
    // | STRING
    //     {$$ = ["string", $1.slice(1, -1)]} //take off the quotes
    
    | TRUE
        {$$ = {next : null, action : ["boolean", true]}}
    | FALSE
        {$$ = {next : null, action : ["boolean", false]}}
    
    // | STR '(' e ')'
    //     {$$ = $3}
    ;