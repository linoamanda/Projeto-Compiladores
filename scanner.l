/****************************************************/
/* File: scanner.lex                                */
/* Lex specification for C--                        */
/****************************************************/


%option noyywrap
%{
#include "globals.h"
#include "util.h"
#include "scanner.h"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

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
"("             {return LPAREN;}
")"             {return RPAREN;}
";"             {return SEMI;}
","             {return COMMA;}
"["             {return LBRACK;}
"]"             {return RBRACK;}
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
             "/*" {
                    char c;
                    while (1) {
                        c = input();
                        if (c == 0 || c == EOF) break;
                        if (c == '\n') lineno++;
                        if (c == '*') {
                            while ((c = input()) == '*');
                            if (c == '/') break;
                            if (c == '\n') lineno++;
                            if (c == 0 || c == EOF) break;
                        }
                    }
                }
 "/"             {return OVER;}
"{"              {return LBRACE;}
"}"              {return RBRACE;}
.                {return ERROR;}

%%

TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = source;
    yyout = target;
  }
  currentToken = yylex();

  if (currentToken == 0) {
    currentToken = ENDFILE;
  }
  strncpy(tokenString,yytext,MAXTOKENLEN);
  if (TraceScan) {
   // fprintf(target,"\t%d: ",lineno);
    printToken(currentToken,tokenString);
  }
  // Força a gravação imediata no arquivo a cada token encontrado:
    // Força a gravação imediata no arquivo a cada token encontrado:
  if (target) fflush(target);

  if (currentToken == ERROR)
  {
    fprintf(stderr, "ERRO LEXICO: simbolo invalido \"%s\" na linha %d\n",
            tokenString, lineno);
   
  }

  return currentToken;
}
