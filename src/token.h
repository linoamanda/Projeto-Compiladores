#ifndef TOKEN_H
#define TOKEN_H

typedef enum
{
    ID,
    ELSE,
    IF,
    INT,
    RETURN,
    VOID,
    WHILE
} TokenType;

TokenType verificaToken(char *lexema);

#endif