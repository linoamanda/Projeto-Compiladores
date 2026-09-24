#include "globals.h"
#include "scanner.h"

FILE *source;
FILE *target;

int lineno = 0;
int TraceScan = 1;

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
        strcat(pgm, ".tny");
    }

    source = fopen(pgm, "r");

    if (source == NULL)
    {
        fprintf(stderr, "Arquivo %s não encontrado.\n", pgm);
        exit(1);
    }

    target = stdout;

    while (getToken() != ENDFILE);

    fclose(source);

    return 0;
}