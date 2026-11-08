#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "globals.h"
#include "scanner.h"
#include "parser.tab.h"

FILE *source;
FILE *target;
extern FILE *yyin;
extern int yyparse(void);

int lineno = 1;
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
        strcat(pgm, ".c--");
    }

    source = fopen(pgm, "r");
    yyin = source;

    if (source == NULL)
    {
        fprintf(stderr, "Arquivo %s não encontrado.\n", pgm);
        exit(1);
    }

    target = fopen("saida.txt", "w");
    if (target == NULL)
    {
        fprintf(stderr, "Arquivo saida.txt não pode ser criado.\n");
        exit(1);
    }
    
    if (yyparse() == 0)
        fprintf(stderr, "Parsing sintatico concluido com sucesso.\n");
    else
        fprintf(stderr, "Falha no parsing sintatico.\n");

    fclose(source);
    fclose(target); 

    return 0;
}