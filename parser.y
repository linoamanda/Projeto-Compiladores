/****************************************************/
/* File: parser.y                                   */
/* Bison specification for C-- (com arvore)         */
/****************************************************/

%code requires {
#include "globals.h"
}

%{
#include <stdio.h>
#include <stdlib.h>
#include "globals.h"
#include "util.h"

#define yylex getToken
int getToken(void);
void yyerror(const char *s);
%}

%union {
    int       ival;     /* tipo e operadores   */
    char     *str;      /* lexema de ID e NUM  */
    TreeNode *node;     /* nos da arvore       */
}

%token ERROR IF ELSE INT RETURN VOID WHILE
%token <str> ID NUM
%token ASSIGN EQ LE GE GT NE LT
%token PLUS MINUS TIMES OVER
%token LPAREN RPAREN SEMI COMMA
%token LBRACK RBRACK LBRACE RBRACE

%type <node> declaracao_lista declaracao var_declaracao fun_declaracao
%type <node> params param_lista param composto_decl local_declaracoes
%type <node> statement_lista statement expressao_decl selecao_decl
%type <node> iteracao_decl retorno_decl expressao var simples_expressao
%type <node> soma_expressao termo fator ativacao args arg_lista
%type <ival> tipo_especificador relacional soma mult
%type <str>  id

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

programa:
      declaracao_lista { savedTree = $1; }
    ;

declaracao_lista:
      declaracao_lista declaracao { $$ = appendSibling($1, $2); }
    | declaracao                  { $$ = $1; }
    ;

declaracao:
      var_declaracao { $$ = $1; }
    | fun_declaracao { $$ = $1; }
    ;

id:
      ID { $$ = $1; }
    ;

var_declaracao:
      tipo_especificador id SEMI
        {
            $$ = newDeclNode(VarK);
            $$->type = $1;
            $$->name = $2;
        }
    | tipo_especificador id LBRACK NUM RBRACK SEMI
        {
            $$ = newDeclNode(ArrayVarK);
            $$->type = $1;
            $$->name = $2;
            $$->val = atoi($4);
            free($4);
        }
    ;

tipo_especificador:
      INT  { $$ = Integer; }
    | VOID { $$ = Void; }
    ;

fun_declaracao:
      tipo_especificador id LPAREN params RPAREN composto_decl
        {
            $$ = newDeclNode(FunK);
            $$->type = $1;
            $$->name = $2;
            $$->child[0] = $4;      /* parametros */
            $$->child[1] = $6;      /* corpo      */
        }
    ;

params:
      param_lista { $$ = $1; }
    | VOID        { $$ = NULL; }
    ;

param_lista:
      param_lista COMMA param { $$ = appendSibling($1, $3); }
    | param                   { $$ = $1; }
    ;

param:
      tipo_especificador id
        {
            $$ = newDeclNode(ParamK);
            $$->type = $1;
            $$->name = $2;
        }
    | tipo_especificador id LBRACK RBRACK
        {
            $$ = newDeclNode(ArrayParamK);
            $$->type = $1;
            $$->name = $2;
        }
    ;

composto_decl:
      LBRACE local_declaracoes statement_lista RBRACE
        {
            $$ = newStmtNode(CompoundK);
            $$->child[0] = $2;      /* declaracoes locais */
            $$->child[1] = $3;      /* comandos           */
        }
    ;

local_declaracoes:
      local_declaracoes var_declaracao { $$ = appendSibling($1, $2); }
    | /* vazio */                      { $$ = NULL; }
    ;

statement_lista:
      statement_lista statement { $$ = appendSibling($1, $2); }
    | /* vazio */               { $$ = NULL; }
    ;

statement:
      expressao_decl { $$ = $1; }
    | composto_decl  { $$ = $1; }
    | selecao_decl   { $$ = $1; }
    | iteracao_decl  { $$ = $1; }
    | retorno_decl   { $$ = $1; }
    ;

expressao_decl:
      expressao SEMI { $$ = $1; }
    | SEMI           { $$ = NULL; }
    ;

selecao_decl:
      IF LPAREN expressao RPAREN statement %prec LOWER_THAN_ELSE
        {
            $$ = newStmtNode(IfK);
            $$->child[0] = $3;
            $$->child[1] = $5;
        }
    | IF LPAREN expressao RPAREN statement ELSE statement
        {
            $$ = newStmtNode(IfK);
            $$->child[0] = $3;
            $$->child[1] = $5;
            $$->child[2] = $7;
        }
    ;

iteracao_decl:
      WHILE LPAREN expressao RPAREN statement
        {
            $$ = newStmtNode(WhileK);
            $$->child[0] = $3;
            $$->child[1] = $5;
        }
    ;

retorno_decl:
      RETURN SEMI
        { $$ = newStmtNode(ReturnK); }
    | RETURN expressao SEMI
        {
            $$ = newStmtNode(ReturnK);
            $$->child[0] = $2;
        }
    ;

expressao:
      var ASSIGN expressao
        {
            $$ = newExpNode(AssignK);
            $$->child[0] = $1;
            $$->child[1] = $3;
        }
    | simples_expressao { $$ = $1; }
    ;

var:
      id
        {
            $$ = newExpNode(IdK);
            $$->name = $1;
        }
    | id LBRACK expressao RBRACK
        {
            $$ = newExpNode(SubscriptK);
            $$->name = $1;
            $$->child[0] = $3;      /* indice */
        }
    ;

simples_expressao:
      soma_expressao relacional soma_expressao
        {
            $$ = newExpNode(OpK);
            $$->op = $2;
            $$->child[0] = $1;
            $$->child[1] = $3;
        }
    | soma_expressao { $$ = $1; }
    ;

relacional:
      LE { $$ = LE; }
    | LT { $$ = LT; }
    | GT { $$ = GT; }
    | GE { $$ = GE; }
    | EQ { $$ = EQ; }
    | NE { $$ = NE; }
    ;

soma_expressao:
      soma_expressao soma termo
        {
            $$ = newExpNode(OpK);
            $$->op = $2;
            $$->child[0] = $1;
            $$->child[1] = $3;
        }
    | termo { $$ = $1; }
    ;

soma:
      PLUS  { $$ = PLUS; }
    | MINUS { $$ = MINUS; }
    ;

termo:
      termo mult fator
        {
            $$ = newExpNode(OpK);
            $$->op = $2;
            $$->child[0] = $1;
            $$->child[1] = $3;
        }
    | fator { $$ = $1; }
    ;

mult:
      TIMES { $$ = TIMES; }
    | OVER  { $$ = OVER; }
    ;

fator:
      LPAREN expressao RPAREN { $$ = $2; }
    | var                     { $$ = $1; }
    | ativacao                { $$ = $1; }
    | NUM
        {
            $$ = newExpNode(ConstK);
            $$->val = atoi($1);
            free($1);
        }
    ;

ativacao:
      id LPAREN args RPAREN
        {
            $$ = newExpNode(CallK);
            $$->name = $1;
            $$->child[0] = $3;      /* argumentos */
        }
    ;

args:
      arg_lista   { $$ = $1; }
    | /* vazio */ { $$ = NULL; }
    ;

arg_lista:
      arg_lista COMMA expressao { $$ = appendSibling($1, $3); }
    | expressao                 { $$ = $1; }
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "Erro sintatico na linha %d: %s\n", lineno, s);
}