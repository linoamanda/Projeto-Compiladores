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
                  char anterior = 0;

                  do
                  {
                      c = input();

                      if (c == EOF)
                          break;

                      if (c == '\n')
                          lineno++;

                      if (anterior == '*' && c == '/')
                          break;

                      anterior = c;

                  } while (1);
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
  strncpy(tokenString,yytext,MAXTOKENLEN);
  if (TraceScan) {
   // fprintf(target,"\t%d: ",lineno);
    printToken(currentToken,tokenString);
  }
  return currentToken;
}

