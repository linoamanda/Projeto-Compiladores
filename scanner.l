/****************************************************/
/* File: scanner.l                                  */
/* Lex specification for C--                        */
/* Tabela de simbolos montada no lexico             */
/****************************************************/

%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "globals.h"
#include "util.h"
#include "symtab.h"
#include "scanner.h"
#include "parser.tab.h"

/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];

/* ---- estado usado para montar a tabela de simbolos ---- */
static int  prev1 = -1, prev2 = -1;       /* ultimos dois tokens        */
static char prevLex[MAXTOKENLEN+1];       /* lexema do ultimo ID        */
static int  prevLine = 0;                 /* linha do ultimo ID         */
static char curScope[MAXTOKENLEN+1] = "global";
static int  depth    = 0;                 /* nivel de chaves { }        */
static int  inParams = 0;                 /* dentro de ( ) da funcao?   */
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t\r]+

%%

"if"            {return IF;}
"else"          {return ELSE;}
"int"           {return INT;}
"return"        {return RETURN;}
"void"          {return VOID;}
"while"         {return WHILE;}
"=="            {return EQ;}
"="             {return ASSIGN;}
"<="            {return LE;}
"<"             {return LT;}
">="            {return GE;}
">"             {return GT;}
"!="            {return NE;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
";"             {return SEMI;}
","             {return COMMA;}
"["             {return LBRACK;}
"]"             {return RBRACK;}
"{"             {return LBRACE;}
"}"             {return RBRACE;}
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}

"/*"            {
                    int c;
                    while (1) {
                        c = input();
                        if (c == 0 || c == EOF) break;
                        if (c == '\n') lineno++;
                        if (c == '*') {
                            while ((c = input()) == '*');
                            if (c == '\n') lineno++;
                            if (c == '/') break;
                            if (c == 0 || c == EOF) break;
                        }
                    }
                }

.               {return ERROR;}

%%

int getToken(void)
{
    int tok;

    /* le o proximo token valido (descarta simbolos invalidos) */
    do {
        tok = yylex();

        strncpy(tokenString, yytext, MAXTOKENLEN);
        tokenString[MAXTOKENLEN] = '\0';

        if (tok == ERROR)
            fprintf(stderr, "ERRO LEXICO: simbolo invalido \"%s\" na linha %d\n",
                    tokenString, lineno);
    } while (tok == ERROR);

    if (TraceScan && target) {
        printToken(tok, tokenString);
        fflush(target);
    }

    /* declaracao: (int|void) ID <token decisivo> */
    if ((prev2 == INT || prev2 == VOID) && prev1 == ID) {
        TipoDado t = (prev2 == INT) ? TIPO_INT : TIPO_VOID;

        if (tok == LPAREN) {                          /* funcao */
            st_insert(prevLex, prevLine, t, ID_FUNC, "global");
            strcpy(curScope, prevLex);
            inParams = 1;
        }
        else if (inParams &&
                 (tok == COMMA || tok == RPAREN || tok == LBRACK)) {
            st_insert(prevLex, prevLine, t, ID_PARAM, curScope);
        }
        else if (!inParams && tok == SEMI) {          /* variavel */
            st_insert(prevLex, prevLine, t, ID_VAR, curScope);
        }
        else if (!inParams && tok == LBRACK) {        /* vetor */
            st_insert(prevLex, prevLine, t, ID_VETOR, curScope);
        }
    }

    /* ID: guarda lexema; se nao vem depois de tipo, e um uso */
    if (tok == ID) {
        if (prev1 != INT && prev1 != VOID)
            st_addRef(tokenString, lineno, curScope);
        strcpy(prevLex, tokenString);
        prevLine = lineno;
    }

    /* controle de escopo */
    if (tok == RPAREN) inParams = 0;
    if (tok == LBRACE) depth++;
    if (tok == RBRACE && --depth == 0)
        strcpy(curScope, "global");

    prev2 = prev1;
    prev1 = tok;

    /* entrega o lexema ao bison */
    if (tok == ID || tok == NUM)
        yylval.str = strdup(yytext);

    return tok;
}