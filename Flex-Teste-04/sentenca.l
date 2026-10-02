%{
#include <stdlib.h>
#include <stdio.h>

/* Palavras-reservadas */
#define IF       258
#define ELSE     259
#define INT      260
#define RETURN   261
#define VOID     262
#define WHILE    263

#define NUM 300
#define ID  301
#define SOM 302
#define SUB 303
#define MUL 304
#define DIV 305
#define IGL 306
#define PEV 307
#define APR 308
#define FPR 309
#define FIM 310
#define ERR 311
#define ACH 312
#define FCH 313
#define ACO 314
#define FCO 315
%}

%option noyywrap

DIGITO [0-9]
LETRA  [a-zA-Z]
OUTRO  [^0-9a-zA-Z;/=\-"+""*""("")"]

%%
{DIGITO}+                   return NUM;
{LETRA}({LETRA}|{DIGITO})*  return ID;
"+"                         return SOM;
"-"                         return SUB;
"*"                         return MUL;
"/"                         return DIV;
"="                         return IGL;
";"                         return PEV;
"("                         return APR;
")"                         return FPR;
"["                         return ACH;
"]"                         return FCH;
"{"                         return ACO;
"}"                         return FCO;
<<EOF>>                     return FIM;
\n                          ;
\t                          ;
[ ]+                        ;
{OUTRO}+                    return ERR;
%%

int main(int argc, char *argv[])
{
  int token, i, buf[100];
  FILE *f_in;

  for (i = 0; i <= 99; i++) buf[i] = 0;

  if (argc == 2)
  {
    if ((f_in = fopen(argv[1], "r"))) yyin = f_in;
    else perror(argv[0]);
  }
  else yyin = stdin;

  i = 0;
  while ((token = yylex()) != FIM && i < 100)
  {
    buf[i] = token;
    i++;
  }

  i = 0;
  while (buf[i] != 0 && i < 100)
  {
    switch(buf[i])
    {
      case NUM: printf("NUM "); break;
      case ID:  printf("ID ");  break;
      case SOM: printf("+ ");   break;
      case SUB: printf("- ");   break;
      case MUL: printf("* ");   break;
      case DIV: printf("/ ");   break;
      case IGL: printf(" = ");  break;
      case PEV: printf("; \n"); break;
      case APR: printf("( ");   break;
      case FPR: printf(") ");   break;
      case ERR: printf("ERR "); break;
      case IF : printf("IF"); break;
      case ELSE : printf ("ELSE");break;
      case INT : printf("INT");break;
      case RETURN : printf("RETURN");break;
      case VOID: printf("VOID");break;
      case WHILE: printf("WHILE");break;
    }
    i++;
  }

  return 0;
}