#include <stdio.h>
#include <ctype.h>

#include "scanner.h"
#include "token.h"

#define MAX_STATES 3
#define MAX_CHARS 256
#define MAX_LEXEME 100

int T[MAX_STATES][MAX_CHARS];
int Avance[MAX_STATES][MAX_CHARS];
int Aceita[MAX_STATES];

void inicializarTabela()
{
    int i;

    for (i = 'a'; i <= 'z'; i++)
    {
        T[1][i] = 2;
        Avance[1][i] = 1;
    }

    for (i = 'A'; i <= 'Z'; i++)
    {
        T[1][i] = 2;
        Avance[1][i] = 1;
    }

    for (i = 'a'; i <= 'z'; i++)
    {
        T[2][i] = 2;
        Avance[2][i] = 1;
    }

    for (i = 'A'; i <= 'Z'; i++)
    {
        T[2][i] = 2;
        Avance[2][i] = 1;
    }

    for (i = '0'; i <= '9'; i++)
    {
        T[2][i] = 2;
        Avance[2][i] = 1;
    }

    Aceita[2] = 1;
}

void copiaComentario(FILE *source, FILE *output)
{
    int ch;
    int anterior;

    fputc('/', output);
    fputc('*', output);

    ch = fgetc(source);
    anterior = 0;

    while (ch != EOF)
    {
        fputc(ch, output);

        if (anterior == '*' && ch == '/')
            return;

        anterior = ch;
        ch = fgetc(source);
    }
}

void scan(FILE *source, FILE *output)
{
    int ch;
    int estado;
    int novoEstado;
    int tamanho;

    char lexema[MAX_LEXEME];

    inicializarTabela();

    ch = fgetc(source);

    while (ch != EOF)
{
    if (ch == '/')
{
    int proximo = fgetc(source);

    if (proximo == '*')
    {
        copiaComentario(source, output);
        ch = fgetc(source);
        continue;
    }

    fputc(ch, output);
    ch = proximo;
    continue;
}

    if (!isalpha(ch))
    {
        fputc(ch, output);
        ch = fgetc(source);
        continue;
    }

        estado = 1;
        tamanho = 0;

        while (ch != EOF && T[estado][ch] != 0)
        {
            novoEstado = T[estado][ch];

            lexema[tamanho] = ch;
            tamanho++;

            if (Avance[estado][ch])
                ch = fgetc(source);

            estado = novoEstado;
        }

        lexema[tamanho] = '\0';

        TokenType token = verificaToken(lexema);

        if (token == ID)
            fprintf(output, "ID");
        else
            fprintf(output, "%s", lexema);
    }
}