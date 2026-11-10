/****************************************************/
/* File: util.c                                     */
/* Utility function implementation                  */
/* for the C-- compiler                            */
/****************************************************/

#include "globals.h"
#include "util.h"
#include "parser.tab.h"

/* Procedure printToken prints a token 
 * and its lexeme to the listing file
 */
void printToken( int token, const char* tokenString )
{ switch (token)
  { case IF:
    case ELSE:
    case INT:
    case RETURN:
    case VOID:
    case WHILE:
     fprintf(target,
         " %s ",tokenString);
      break;
    case EQ: fprintf(target," == "); break;
    case ASSIGN: fprintf(target, "= "); break;
    case LT: fprintf(target," < "); break;
    case LE: fprintf(target,"  <= "); break;
    case GE: fprintf(target,">= "); break;
    case GT: fprintf(target,"> "); break;
    case NE: fprintf(target,"!= "); break;
    case PLUS: fprintf(target," + "); break;
    case MINUS: fprintf(target," - "); break;
    case TIMES: fprintf(target," * "); break;
    case LPAREN: fprintf(target," (\n"); break;
    case RPAREN: fprintf(target," )\n"); break;
    case SEMI: fprintf(target,"; "); break;
    case COMMA: fprintf(target,","); break;
    case LBRACK: fprintf(target," [ "); break;
    case RBRACK: fprintf(target," ] "); break;
    case 0: fprintf(target,"EOF\n"); break;
    case NUM:
      fprintf(target,
          "NUM %s ",tokenString);
      break;
    case ID:
      fprintf(target,
          "ID %s ",tokenString);
      break;
    case OVER: fprintf(target,"OVER/\n"); break;
    case LBRACE: fprintf(target,"  {\n"); break;
    case RBRACE: fprintf(target,"  }\n"); break;
    case ERROR:
    fprintf(target,
        "ERROR: simbolo invalido \"%s\" na linha %d\n", tokenString, lineno);
    break;
    default: /* should never happen */
      fprintf(target,"Unknown token: %d\n",token);
  }
}

/* ------------------------------------------------------------------ */
/* Arvore sintatica                                                    */
/* ------------------------------------------------------------------ */

/* Cria um no zerado: filhos e irmao ja nascem NULL. */
static TreeNode *newNode(NodeKind nk)
{
    TreeNode *t = (TreeNode *) calloc(1, sizeof(TreeNode));
    if (t == NULL)
    {
        fprintf(stderr, "Sem memoria para criar no da arvore.\n");
        exit(1);
    }
    t->nodekind = nk;
    return t;
}

TreeNode *newStmtNode(StmtKind k)
{
    TreeNode *t = newNode(StmtK);
    t->kind.stmt = k;
    return t;
}

TreeNode *newExpNode(ExpKind k)
{
    TreeNode *t = newNode(ExpK);
    t->kind.exp = k;
    return t;
}

TreeNode *newDeclNode(DeclKind k)
{
    TreeNode *t = newNode(DeclK);
    t->kind.decl = k;
    return t;
}

/* Liga b ao fim da lista de irmaos de a. Aceita NULL nos dois lados. */
TreeNode *appendSibling(TreeNode *a, TreeNode *b)
{
    TreeNode *t = a;
    if (a == NULL) return b;
    while (t->sibling != NULL) t = t->sibling;
    t->sibling = b;
    return a;
}

static const char *opString(int op)
{
    switch (op)
    {
        case PLUS:  return "+";
        case MINUS: return "-";
        case TIMES: return "*";
        case OVER:  return "/";
        case LT:    return "<";
        case LE:    return "<=";
        case GT:    return ">";
        case GE:    return ">=";
        case EQ:    return "==";
        case NE:    return "!=";
        default:    return "?";
    }
}

static const char *typeString(ExpType t)
{
    return (t == Integer) ? "int" : "void";
}

void printTree(TreeNode *t, int indent)
{
    int i;
    while (t != NULL)                         /* anda pelos irmaos */
    {
        for (i = 0; i < indent; i++) printf("  ");

        switch (t->nodekind)
        {
            case StmtK:
                switch (t->kind.stmt)
                {
                    case IfK:       printf("If\n"); break;
                    case WhileK:    printf("While\n"); break;
                    case ReturnK:   printf("Return\n"); break;
                    case CompoundK: printf("Composto\n"); break;
                }
                break;
            case ExpK:
                switch (t->kind.exp)
                {
                    case OpK:        printf("Op: %s\n", opString(t->op)); break;
                    case ConstK:     printf("Const: %d\n", t->val); break;
                    case IdK:        printf("Id: %s\n", t->name); break;
                    case SubscriptK: printf("Id: %s[]\n", t->name); break;
                    case AssignK:    printf("Atribuicao\n"); break;
                    case CallK:      printf("Chamada: %s\n", t->name); break;
                }
                break;
            case DeclK:
                switch (t->kind.decl)
                {
                    case VarK:
                        printf("Var: %s %s\n", typeString(t->type), t->name);
                        break;
                    case ArrayVarK:
                        printf("Var: %s %s[%d]\n", typeString(t->type), t->name, t->val);
                        break;
                    case FunK:
                        printf("Funcao: %s %s\n", typeString(t->type), t->name);
                        break;
                    case ParamK:
                        printf("Parametro: %s %s\n", typeString(t->type), t->name);
                        break;
                    case ArrayParamK:
                        printf("Parametro: %s %s[]\n", typeString(t->type), t->name);
                        break;
                }
                break;
        }

        for (i = 0; i < 3; i++)     /* desce pelos filhos */
            printTree(t->child[i], indent + 1);

        t = t->sibling;                       /* proximo irmao */
    }
}