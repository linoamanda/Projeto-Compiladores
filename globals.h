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