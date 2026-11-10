#ifndef GLOBALS_H
#define GLOBALS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef FALSE
#define FALSE 0
#endif

#ifndef TRUE
#define TRUE 1
#endif

#define MAXCHILDREN 3

/* Familia do no
   StmtK: Statement (comando)
   ExpK:  Expression (expressao)
   DeclK: Declaration (declaracao) */
typedef enum { StmtK, ExpK, DeclK } NodeKind;

/* Tipo especifico dentro de cada familia */
typedef enum { IfK, WhileK, ReturnK, CompoundK } StmtKind;                /* comandos    */
typedef enum { OpK, ConstK, IdK, SubscriptK, AssignK, CallK } ExpKind;    /* expressoes  */
typedef enum { VarK, ArrayVarK, FunK, ParamK, ArrayParamK } DeclKind;     /* declaracoes */

/* tipo declarado: int ou void */
typedef enum { Void, Integer } ExpType;

typedef struct treeNode
{
    struct treeNode *child[MAXCHILDREN];  /* partes fixas do no          */
    struct treeNode *sibling;             /* proximo elemento da lista   */
    NodeKind nodekind;
    union { StmtKind stmt; ExpKind exp; DeclKind decl; } kind;
    int op;          /* OpK: token do operador (PLUS, LT, ...)           */
    int val;         /* ConstK: valor; ArrayVarK: tamanho                */
    char *name;      /* IdK, SubscriptK, CallK e declaracoes: nome       */
    ExpType type;    /* declaracoes: int ou void                         */
} TreeNode;

extern TreeNode *savedTree;   /* raiz da arvore, preenchida pelo parser */

extern FILE *source;
extern FILE *target;
extern int lineno;
extern int TraceScan;

#endif