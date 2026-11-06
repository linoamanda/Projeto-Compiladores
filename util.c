/****************************************************/
/* File: util.c                                     */
/* Utility function implementation                  */
/* for the C-- compiler                            */
/****************************************************/

#include "globals.h"
#include "util.h"

/* Procedure printToken prints a token 
 * and its lexeme to the listing file
 */
void printToken( TokenType token, const char* tokenString )
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
    case ENDFILE: fprintf(target,"EOF\n"); break;
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