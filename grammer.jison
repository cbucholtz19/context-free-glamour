%lex

%%

[#][^\r\n|\r|\n]*              return "COMMENT"
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
"and"                          return "AND"
"or"                           return "OR"

":"                            return ':'
"if"                           return 'IF'
"else"                         return 'ELSE'
"elif"                         return "ELIF"
"while"                        return "WHILE"
"for"                          return "FOR"
"range"                        return "RANGE"
"in"                           return "IN"
","                            return ','

"print"                        return "PRINT"
"str"                          return "STR"
["][^"]*["]                    return "STRING"
[0-9]+("."[0-9]+)?\b           return "NUMBER"
[a-zA-Z|_]([a-zA-Z]|[0-9]|_)*  return "VARIABLE"
<<EOF>>                        return "EOF"
.                              return "UNKNOWN_TOKEN"

/lex

%left AND OR
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
    : VARIABLE '+=' e lineend line
        {$$ = {next : $line, action : ["+=", $VARIABLE, $e]}}
    | VARIABLE '-=' e lineend line
        {$$ = {next : $line, action : ["-=", $VARIABLE, $e]}}
    | VARIABLE '**=' e lineend line
        {$$ = {next : $line, action : ["**=", $VARIABLE, $e]}}
    | VARIABLE '*=' e lineend line
        {$$ = {next : $line, action : ["*=", $VARIABLE, $e]}}
    | VARIABLE '/=' e lineend line
        {$$ = {next : $line, action : ["/=", $VARIABLE, $e]}}
    | VARIABLE '%=' e lineend line
        {$$ = {next : $line, action : ["%=", $VARIABLE, $e]}}
    | VARIABLE '=' e lineend line
        {$$ = {next : $line, action : ["set_variable", $VARIABLE, $e]}}

    | PRINT '(' e ')' lineend line
        {$$ = {next : $line, action : ["print", $e]}}

    | IF e ':' '{' line '}' elseif line
        {$$ = {next : $8, action : ["if", $e, $5, $elseif]}}

    | WHILE e ':' '{' line '}' line
        {$$ = {next : $7, action : ["while", $e, $5]}}
    
    | FOR VARIABLE IN RANGE '(' e ',' e ')' ':' '{' line '}' line
        {$$ = {next : $14, action : ["for", $6, $8, $VARIABLE, $12]}}

    | COMMENT lineend line
        {$$ = {next : $line, action : ["no_op"]}}
    | lineend line
        {$$ = {next : $line, action : ["no_op"]}}
    |
        {$$ = {next : null, action : ["no_op"]}}
    ;

elseif
    : ELIF e ':' '{' line '}' elseif
        {$$ = {next : null, action : ["if", $e, $5, $elseif]}}
    | ELSE ':' '{' line '}'
        {$$ = {next : null, action : ["else", $line]}}
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
    : '(' e ')'
        {$$ = $2;}
    
    | '-' e
        {$$ = {next : null, action : ["-pre", $2]}}

    | e AND e
        {$$ = {next : null, action : ["&&", $1, $3]}}
    | e OR e
        {$$ = {next : null, action : ["||", $1, $3]}}
    
    | e '+' e
        {$$ = {next : null, action : ["+", $1, $3]}}
    | e '-' e
        {$$ = {next : null, action : ["-", $1, $3]}}
    | e '**' e
        {$$ = {next : null, action : ["**", $1, $3]}}
    | e '*' e
        {$$ = {next : null, action : ["*", $1, $3]}}
    | e '/' e
        {$$ = {next : null, action : ["/", $1, $3]}}
    | e '%' e
        {$$ = {next : null, action : ["%", $1, $3]}}

    | e '<=' e
        {$$ = {next : null, action : ["<=", $1, $3]}}
    | e '>=' e
        {$$ = {next : null, action : [">=", $1, $3]}}
    | e '<' e
        {$$ = {next : null, action : ["<", $1, $3]}}
    | e '>' e
        {$$ = {next : null, action : [">", $1, $3]}}
    | e '==' e
        {$$ = {next : null, action : ["==", $1, $3]}}
    | e '!=' e
        {$$ = {next : null, action : ["!=", $1, $3]}}

    | NUMBER
        {$$ = {next : null, action : ["number", Number($1)]}} //parse string to number
    | VARIABLE
        {$$ = {next : null, action : ["variable", $VARIABLE]}}
    | STRING
        {$$ = {next : null, action : ["string", $1.slice(1, -1)]}} //take off the quotes
    
    | TRUE
        {$$ = {next : null, action : ["boolean", true]}}
    | FALSE
        {$$ = {next : null, action : ["boolean", false]}}
    
    | STR '(' e ')'
        {$$ = $3}
    ;