%{
#include <stdio.h>
%}

%%

"if"        { printf("IF\n"); }

[0-9]+      { printf("NUM: %s\n", yytext); }

[a-zA-Z]+   { printf("ID: %s\n", yytext); }

"+"         { printf("PLUS\n"); }

[ \t\n]+    { /* ignora espaços */ }

.           { printf("CARACTERE: %s\n", yytext); }

%%

int yywrap(void)
{
    return 1;
}

int main(void)
{
    yylex();
    return 0;
}