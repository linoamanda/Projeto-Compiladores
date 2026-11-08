/****************************************************/
/* File: parser.y                                */
/* Bison specification for C--                        */
/****************************************************/


%{
#include <stdio.h>
#include <stdlib.h>
#include "globals.h"

#define yylex getToken
int getToken(void);
void yyerror(const char *s);

%}

%token ERROR IF ELSE INT RETURN VOID WHILE
%token ID NUM
%token ASSIGN EQ LE GE GT NE LT
%token PLUS MINUS TIMES OVER
%token LPAREN RPAREN SEMI COMMA
%token LBRACK RBRACK LBRACE RBRACE

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

programa:
      declaracao_lista { }
    ;

declaracao_lista:
      declaracao_lista declaracao { }
    | declaracao { }
    ;

declaracao:
      var_declaracao { }
    | fun_declaracao { }
    ;

id:
      ID { }
    ; 

fid:
      /* vazio */ { }
    ; 

var_declaracao:
      tipo_especificador var SEMI { }
    ;

tipo_especificador:
      INT { } 
    | VOID { }
    ;

fun_declaracao:
      tipo_especificador id fid LPAREN params RPAREN composto_decl { }
    ;

params:
      param_lista { }
    | VOID { }
    ;

param_lista:
      param_lista COMMA param { }
    | param { }
    ;

param:
      tipo_especificador id { }
    | tipo_especificador id LBRACK RBRACK { }
    ;

composto_decl:
      LBRACE local_declaracoes statement_lista RBRACE { }
    ;

local_declaracoes:
      local_declaracoes var_declaracao { }
    | /* vazio */ { }
    ;

statement_lista:
      statement_lista statement { }
    | /* vazio */ { }
    ;

statement:
      expressao_decl { }
    | composto_decl { }
    | selecao_decl { }
    | iteracao_decl { }
    | retorno_decl { }
    ;

expressao_decl:
      expressao SEMI { }
    | SEMI { }
    ;

selecao_decl:
      IF LPAREN expressao RPAREN statement %prec LOWER_THAN_ELSE { }
    | IF LPAREN expressao RPAREN statement ELSE statement { }
    ;

iteracao_decl:
      WHILE LPAREN expressao RPAREN statement { }
    ;

retorno_decl:
      RETURN SEMI { }
    | RETURN expressao SEMI { }
    ;

expressao:
      var ASSIGN expressao { }
    | simples_expressao { }
    ;

var:
      id { }
    | id LBRACK expressao RBRACK { }
    ;

var2:
      id { }
    ;

simples_expressao:
      soma_expressao relacional soma_expressao { }
    | soma_expressao { }
    ;

relacional:
      LE { }
    | LT { }
    | GT { }
    | GE { }
    | EQ { }
    | NE { }
    ;

soma_expressao:
      soma_expressao soma termo { }
    | termo { }
    ;

soma:
      PLUS { }
    | MINUS { }
    ;

termo:
      termo mult fator { }
    | fator { }
    ;

mult:
      TIMES { }
    | OVER { }
    ;

fator:
      LPAREN expressao RPAREN { }
    | var { }
    | ativacao { }
    | NUM { }
    ;

ativacao:
      var2 LPAREN args RPAREN { }
    ;

args:
      arg_lista { }
    | /* vazio */ { }
    ;

arg_lista:
      arg_lista COMMA expressao { }
    | expressao { }
    ;

%%

void yyerror(const char *s)
{
    if (target != NULL) {
        fprintf(stderr, "Erro sintatico na linha %d: %s\n", lineno, s);
    }

}
