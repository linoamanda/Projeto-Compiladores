#include <stdio.h>
#include "scanner.h"
#include "token.h"
#include <ctype.h>

void scan(void)
{
    int c;

    while ((c = getchar()) != EOF)
    {
        if (isspace(c))
        {
            continue;
        }

        switch (c)
        {
            case '+':
                printf("PLUS\n");
                break;

            default:
                printf("UNKNOWN: %c\n", c);
        }
    }
}