/****************************************************/
/* File: scanner.lex                                */
/* Analisador Léxico + Parser Descendente Recursivo */
/* Gramática G2                                     */
/****************************************************/

%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef FALSE
#define FALSE 0
#endif

#ifndef TRUE
#define TRUE 1
#endif

/* Enumeração dos Tokens para a Gramática G2 */
typedef enum
{
    ENDFILE = 0,
    ERROR   = 1,
    NUM     = 2,
    PLUS    = 3,
    MINUS   = 4,
    TIMES   = 5,
    OVER    = 6,
    LPAREN  = 7,
    RPAREN  = 8
} TokenType;

#define MAXTOKENLEN 40

/* Variáveis Globais */
FILE *source;
FILE *target;
int lineno = 0;
int TraceScan = 0; /* Define como 1 se quiseres ver a impressão dos tokens */
char tokenString[MAXTOKENLEN + 1];

TokenType currentToken;

/* Protótipos das Funções Léxicas */
TokenType getToken(void);
void printToken(TokenType, const char *);

/* Protótipos do Parser Descendente Recursivo */
void exp_syntax(void);
void termo(void);
void fator(void);
void match(TokenType expected);
void syntaxError(const char *message);

%}

digit       [0-9]
number      {digit}+
newline     \n
whitespace  [ \t]+

%%

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return OVER; }
"("             { return LPAREN; }
")"             { return RPAREN; }
{number}        { return NUM; }
{newline}       { lineno++; }
{whitespace}    { /* ignora espaços e tabulações */ }
.               { return ERROR; }

%%

/* ==================================================== */
/* 1. IMPLEMENTAÇÃO DO ANALISADOR LÉXICO (getToken)     */
/* ==================================================== */

TokenType getToken(void)
{
    static int firstTime = TRUE;
    TokenType token;

    if (firstTime)
    {
        firstTime = FALSE;
        lineno++;
        yyin = source;
        yyout = target;
    }

    token = yylex();

    if (token == 0) {
        token = ENDFILE;
    }

    strncpy(tokenString, yytext, MAXTOKENLEN);

    if (TraceScan) {
        printToken(token, tokenString);
    }

    if (token == ERROR)
    {
        fprintf(stderr, "ERRO LÉXICO: símbolo inválido \"%s\" na linha %d\n", tokenString, lineno);
        exit(1);
    }

    return token;
}

void printToken(TokenType token, const char* str)
{
    switch (token)
    {
        case PLUS:   printf(" + "); break;
        case MINUS:  printf(" - "); break;
        case TIMES:  printf(" * "); break;
        case OVER:   printf(" / "); break;
        case LPAREN: printf(" ( "); break;
        case RPAREN: printf(" ) "); break;
        case NUM:    printf("NUM(%s) ", str); break;
        case ENDFILE:printf("EOF\n"); break;
        default:     printf("ERROR "); break;
    }
}

/* ==================================================== */
/* 2. IMPLEMENTAÇÃO DO PARSER DESCENDENTE RECURSIVO    */
/* ==================================================== */

void syntaxError(const char *message)
{
    fprintf(stderr, "ERRO SINTÁTICO: %s no token '%s' (linha %d)\n", message, tokenString, lineno);
    exit(1);
}

void match(TokenType expected)
{
    if (currentToken == expected) {
        currentToken = getToken(); /* Avança para o próximo token */
    } else {
        syntaxError("Token inesperado");
    }
}

/* fator -> ( exp ) | NUM */
void fator(void)
{
    if (currentToken == LPAREN) {
        match(LPAREN);
        exp_syntax();
        match(RPAREN);
    } else if (currentToken == NUM) {
        match(NUM);
    } else {
        syntaxError("Esperado '(' ou um número");
    }
}

/* termo -> fator { (* | /) fator } */
void termo(void)
{
    fator();
    while (currentToken == TIMES || currentToken == OVER) {
        if (currentToken == TIMES) {
            match(TIMES);
            fator();
        } else if (currentToken == OVER) {
            match(OVER);
            fator();
        }
    }
}

/* exp -> termo { (+ | -) termo } */
void exp_syntax(void)
{
    termo();
    while (currentToken == PLUS || currentToken == MINUS) {
        if (currentToken == PLUS) {
            match(PLUS);
            termo();
        } else if (currentToken == MINUS) {
            match(MINUS);
            termo();
        }
    }
}

/* ==================================================== */
/* 3. FUNÇÃO PRINCIPAL (MAIN)                           */
/* ==================================================== */

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(stderr, "Uso: %s <arquivo_de_entrada>\n", argv[0]);
        return 1;
    }

    source = fopen(argv[1], "r");
    if (source == NULL)
    {
        fprintf(stderr, "Erro ao abrir o arquivo %s\n", argv[1]);
        return 1;
    }

    /* Carrega o primeiro token para iniciar (lookahead) */
    currentToken = getToken();

    /* Chama a regra inicial da gramática */
    exp_syntax();

    /* Verifica se chegou ao fim da entrada sem erros */
    if (currentToken == ENDFILE) {
        printf("\n>>> Análise Léxica e Sintática concluídas com SUCESSO! <<<\n");
    } else {
        syntaxError("Símbolo extra após o fim da expressão");
    }

    fclose(source);
    return 0;
}