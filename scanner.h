#ifndef SCANNER_H
#define SCANNER_H

#include "globals.h"

#define MAXTOKENLEN 40

extern char tokenString[MAXTOKENLEN + 1];

TokenType getToken(void);

#endif