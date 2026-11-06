%{
#include <stdio.h>
#include <stdlib.h>
%}

%token INT ID SEMI

%%

program:
    INT ID SEMI
    ;

%%

int yyerror(const char *s)
{
    fprintf(stderr, "Erro sintatico: %s\n", s);
    return 0;
}