#ifndef SYMTAB_H
#define SYMTAB_H

#include <stdio.h>

typedef enum { TIPO_INT, TIPO_VOID } TipoDado;
typedef enum { ID_VAR, ID_VETOR, ID_FUNC, ID_PARAM } TipoId;

/* Insere uma declaracao. Se o nome ja existe nesse escopo,
   apenas acrescenta a linha. */
void st_insert(char *name, int lineno, TipoDado tipo, TipoId kind, char *scope);

/* Registra um uso do identificador: procura no escopo atual
   e, se nao achar, no escopo "global". */
void st_addRef(char *name, int lineno, char *scope);

/* Imprime a tabela no arquivo informado */
void printSymTab(FILE *listing);

#endif