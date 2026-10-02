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
    fclose(source);
    fclose(target);
    exit(1);
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
         "reserved word %s\n",tokenString);
      break;
    case EQ: fprintf(target,"EQ ==\n"); break;
    case ASSIGN: fprintf(target, "ASSIGN =\n"); break;
    case LT: fprintf(target,"LT <\n"); break;
    case LE: fprintf(target," LE <=\n"); break;
    case GE: fprintf(target," GE >=n"); break;
    case GT: fprintf(target,"GT >\n"); break;
    case NE: fprintf(target,"NE !=\n"); break;
    case PLUS: fprintf(target,"PLUS +\n"); break;
    case MINUS: fprintf(target,"MINUS -\n"); break;
    case TIMES: fprintf(target,"TIMES *\n"); break;
    case LPAREN: fprintf(target,"LPAREN (\n"); break;
    case RPAREN: fprintf(target,"RPAREN )\n"); break;
    case SEMI: fprintf(target," SEMI ;\n"); break;
    case COMMA: fprintf(target,"COMMA ,\n"); break;
    case LBRACK: fprintf(target,"LBRACK [\n"); break;
    case RBRACK: fprintf(target,"RBRACK ]\n"); break;
    case ENDFILE: fprintf(target,"EOF\n"); break;
    case NUM:
      fprintf(target,
          "NUM %s\n",tokenString);
      break;
    case ID:
      fprintf(target,
          "ID %s\n",tokenString);
      break;
    case OVER: fprintf(target,"OVER/\n"); break;
    case LBRACE: fprintf(target," LBRACE {\n"); break;
    case RBRACE: fprintf(target," RBRACE }\n"); break;
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