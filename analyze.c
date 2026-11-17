#include <stdio.h>
#include <string.h>
#include "globals.h"
#include "analyze.h"
#include "symtab.h"

static char      curScope[64] = "global";
static int       Error = 0;
static TreeNode *root  = NULL;

static void semError(TreeNode *t, const char *msg)
{
    fprintf(stderr, "ERRO SEMANTICO: %s (\"%s\") na linha %d\n",
            msg, t->name ? t->name : "", t->lineno);
    Error = 1;
}

/* procura a declaracao de funcao na arvore */
static TreeNode *findFunc(const char *name)
{
    for (TreeNode *n = root; n; n = n->sibling)
        if (n->nodekind == DeclK && n->kind.decl == FunK && !strcmp(n->name, name))
            return n;
    return NULL;
}
// função uso para contar o número de nós, serve para verificar se o número de parâmetros etsá certo
static int countList(TreeNode *l)
{
    int n = 0;
    for (; l; l = l->sibling) n++;
    return n;
}

/* tipo de uma expressao */
static ExpType expType(TreeNode *t)
{
    TipoDado td; TipoId k;
    if (t == NULL) return Void;

    switch (t->kind.exp) {
    case IdK:
        if (st_lookup(t->name, curScope, &td, &k))
            return td == TIPO_INT ? Integer : Void;
        return Void;
    case CallK: {
        TreeNode *f = findFunc(t->name);
        if (f) return f->type;
        if (!strcmp(t->name, "input"))  return Integer;
        return Void;                               /* output */
    }
    case AssignK: return expType(t->child[0]);
    default:      return Integer;   /* ConstK, OpK, SubscriptK */
    }
}

static void checkPre(TreeNode *t)
{
    TipoDado td; TipoId k;

    if (t->nodekind == DeclK) {
        if (t->kind.decl == FunK)
            strcpy(curScope, t->name);
        /* regra 3: void so para funcao */
        else if (t->type == Void)
            semError(t, "declaracao invalida de variavel (void)");
    }

    if (t->nodekind == ExpK) {
        switch (t->kind.exp) {
        case IdK:
        case SubscriptK:                           /* regra 1 */
            if (!st_lookup(t->name, curScope, &td, &k))
                semError(t, "variavel nao declarada");
            break;

        case CallK: {                              // regras de chamada de função
            TreeNode *f = findFunc(t->name);
            int esperados;

            if (f)                                  esperados = countList(f->child[0]);
            else if (!strcmp(t->name, "input"))     esperados = 0;
            else if (!strcmp(t->name, "output"))    esperados = 1;
            else {
                semError(t, "chamada de funcao nao declarada");
                break;
            }
            if (countList(t->child[0]) != esperados)
                semError(t, "chamada invalida, numero de parametros invalido");
            break;
        }
        default: break;
        }
    }
}

static void checkPost(TreeNode *t)
{
    if (t->nodekind == DeclK && t->kind.decl == FunK)
        strcpy(curScope, "global");

    /* regra 2: atribuir expressao sem valor (funcao void) */
    if (t->nodekind == ExpK && t->kind.exp == AssignK)
        if (expType(t->child[1]) == Void)
            semError(t->child[0], "atribuicao invalida");
}
//busca em profundidade
static void traverse(TreeNode *t,
                     void (*pre)(TreeNode *), void (*post)(TreeNode *))
{
    if (t == NULL) return;
    pre(t);
    for (int i = 0; i < MAXCHILDREN; i++)
        traverse(t->child[i], pre, post);
    post(t);
    traverse(t->sibling, pre, post);
}

void typeCheck(TreeNode *syntaxTree)
{
    root = syntaxTree;
    traverse(syntaxTree, checkPre, checkPost);

    /* regra 6 */
    if (findFunc("main") == NULL) {
        fprintf(stderr, "ERRO SEMANTICO: funcao main() nao declarada\n");
        Error = 1;
    }
    if (!Error)
        fprintf(stderr, "Analise semantica concluida sem erros.\n");
}