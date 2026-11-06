/****************************************************/
/* File: scanner.lex                                */
/* Lex specification for C--                        */
/****************************************************/


%option noyywrap
%{
/* ---------- conteúdo de globals.h ---------- */
#ifndef GLOBALS_H
#define GLOBALS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef FALSE
#define FALSE 0
#endif

#ifndef TRUE
#define TRUE 1
#endif



typedef enum
{
    ENDFILE = 0,
    ERROR   = 1,

    IF      = 2,
    ELSE    = 3,
    INT     = 4,
    RETURN  = 5,
    VOID    = 6,
    WHILE   = 7,

    ID      = 8,
    NUM     = 9,

    ASSIGN  = 10,
    EQ      = 11,
    LE      = 12,
    GE      = 13,
    GT      = 14,
    NE      = 15,
    LT      = 16,
    PLUS    = 17,
    MINUS   = 18,
    TIMES   = 19,
    OVER    = 20,
    LPAREN  = 21,
    RPAREN  = 22,
    SEMI    = 23,
    COMMA   = 24,
    LBRACK  = 25,
    RBRACK  = 26,
    LBRACE  = 27,
    RBRACE  = 28

} TokenType;

extern FILE *source;
extern FILE *target;
extern int lineno;
extern int TraceScan;

#endif

/* ---------- conteúdo de util.h ---------- */
#ifndef UTIL_H
#define UTIL_H

void printToken(TokenType, const char *);

#endif

/* ---------- conteúdo de scanner.h ---------- */
#ifndef SCANNER_H
#define SCANNER_H

#define MAXTOKENLEN 40

extern char tokenString[MAXTOKENLEN + 1];

TokenType getToken(void);

#endif

/* ---------- variáveis globais (antigo main.c) ---------- */
FILE *source;
FILE *target;

int lineno = 0;
int TraceScan = 1;

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

/****************************************************/
/* File: util.c                                     */
/* Utility function implementation                  */
/* for the C-- compiler                            */
/****************************************************/

/* Procedure printToken prints a token 
 * and its lexeme to the listing file
 */
void printToken( TokenType token, const char* tokenString )
{ switch (token)
  { case IF:
    case ELSE:
    case INT:
    case RETURN:
    case VOID:
    case WHILE:
     fprintf(target,
         " %s ",tokenString);
      break;
    case EQ: fprintf(target," == "); break;
    case ASSIGN: fprintf(target, " = "); break;
    case LT: fprintf(target," < "); break;
    case LE: fprintf(target,"  <="); break;
    case GE: fprintf(target,"  >="); break;
    case GT: fprintf(target," > "); break;
    case NE: fprintf(target," != "); break;
    case PLUS: fprintf(target," + "); break;
    case MINUS: fprintf(target," - "); break;
    case TIMES: fprintf(target," * "); break;
    case LPAREN: fprintf(target," ( "); break;
    case RPAREN: fprintf(target," ) "); break;
    case SEMI: fprintf(target,"  ; "); break;
    case COMMA: fprintf(target," , "); break;
    case LBRACK: fprintf(target," [ "); break;
    case RBRACK: fprintf(target," ] "); break;
    case ENDFILE: fprintf(target,"EOF\n"); break;
    case NUM:
      fprintf(target,
          "NUM %s ",tokenString);
      break;
    case ID:
      fprintf(target,
          "ID %s ",tokenString);
      break;
    case OVER: fprintf(target,"OVER/\n"); break;
    case LBRACE: fprintf(target," { \n"); break;
    case RBRACE: fprintf(target,"  }\n"); break;
    case ERROR:
    fprintf(target,
        "ERROR: simbolo invalido \"%s\" na linha %d\n", tokenString, lineno);
    break;
    default: /* should never happen */
      fprintf(target,"Unknown token: %d\n",token);
  }
}

/****************************************************/
/* main (antigo main.c)                             */
/****************************************************/

int main(int argc, char *argv[])
{
    char pgm[120];

    if (argc != 2)
    {
        fprintf(stderr, "Uso: %s <arquivo de entrada>\n", argv[0]);
        return 1;
    }

    strcpy(pgm, argv[1]);

    if (strchr(pgm, '.') == NULL)
    {
        strcat(pgm, ".c--");
    }

    source = fopen(pgm, "r");

    if (source == NULL)
    {
        fprintf(stderr, "Arquivo %s não encontrado.\n", pgm);
        exit(1);
    }

    //target = stdout;
    target = fopen("saida.txt", "w");
    if (target == NULL)
    {
        fprintf(stderr, "Arquivo saida.txt não pode ser criado.\n");
        exit(1);
    }

    while (getToken() != ENDFILE);

    fclose(source);
    fclose(target); 

    return 0;
}