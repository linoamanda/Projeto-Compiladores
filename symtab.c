#include <stdlib.h>
#include <string.h>
#include "symtab.h"

#define MAXLINES 64

typedef struct Symbol {
    char    *name;
    char    *scope;
    TipoDado tipo;
    TipoId   kind;
    int      lines[MAXLINES];
    int      nlines;
    struct Symbol *next;
} Symbol;

/* lista encadeada em ordem de insercao */
static Symbol *head = NULL, *tail = NULL;

static Symbol *find(char *name, char *scope)
{
    for (Symbol *s = head; s; s = s->next)
        if (!strcmp(s->name, name) && !strcmp(s->scope, scope))
            return s;
    return NULL;
}

static void addLine(Symbol *s, int line)
{
    /* evita repetir a mesma linha em sequencia */
    if (s->nlines > 0 && s->lines[s->nlines - 1] == line)
        return;
    if (s->nlines < MAXLINES)
        s->lines[s->nlines++] = line;
}

void st_insert(char *name, int lineno, TipoDado tipo, TipoId kind, char *scope)
{
    Symbol *s = find(name, scope);

    if (s == NULL) {
        s = calloc(1, sizeof(Symbol));
        s->name  = strdup(name);
        s->scope = strdup(scope);
        s->tipo  = tipo;
        s->kind  = kind;
        s->next  = NULL;

        if (tail) tail->next = s;
        else      head = s;
        tail = s;
    }
    addLine(s, lineno);
}

void st_addRef(char *name, int lineno, char *scope)
{
    Symbol *s = find(name, scope);        /* escopo atual */
    if (s == NULL)
        s = find(name, "global");         /* senao, global */
    if (s != NULL)
        addLine(s, lineno);
}

void printSymTab(FILE *f)
{
    static const char *tipos[] = { "int", "void" };
    static const char *kinds[] = { "var", "vetor", "func", "param" };

    fprintf(f, "%-12s %-12s %-6s %-6s %s\n",
            "Nome", "Escopo", "Tipo", "Id", "Linhas");
    fprintf(f, "------------------------------------------------\n");

    for (Symbol *s = head; s; s = s->next) {
        fprintf(f, "%-12s %-12s %-6s %-6s",
                s->name, s->scope, tipos[s->tipo], kinds[s->kind]);
        for (int i = 0; i < s->nlines; i++)
            fprintf(f, " %d", s->lines[i]);
        fprintf(f, "\n");
    }
}