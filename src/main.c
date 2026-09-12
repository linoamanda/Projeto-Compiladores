#include <stdio.h>
#include "scanner.h"

int main()
{
    FILE *source;
    FILE *output;

    source = fopen("../tests/scanner/sort.txt", "r");
    output = fopen("../tests/scanner/saida.txt", "w");

    if (source == NULL)
    {
        printf("Erro ao abrir arquivo de entrada.\n");
        return 1;
    }

    if (output == NULL)
    {
        printf("Erro ao criar arquivo de saída.\n");
        return 1;
    }

    scan(source, output);

    fclose(source);
    fclose(output);

    return 0;
}