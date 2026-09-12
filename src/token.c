#include <string.h>
#include "token.h"

TokenType verificaToken(char *lexema)
{
    if (strcmp(lexema, "else") == 0)
        return ELSE;

    if (strcmp(lexema, "if") == 0)
        return IF;

    if (strcmp(lexema, "int") == 0)
        return INT;

    if (strcmp(lexema, "return") == 0)
        return RETURN;

    if (strcmp(lexema, "void") == 0)
        return VOID;

    if (strcmp(lexema, "while") == 0)
        return WHILE;

    return ID;
}