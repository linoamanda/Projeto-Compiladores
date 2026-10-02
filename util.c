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
         "reserved word %s\n",tokenString);
      break;
    case EQ: fprintf(target,"EQ ==\n"); break;
    case ASSIGN: fprintf(target, "ASSIGN =\n"); break;
    case LT: fprintf(target,"LT <\n"); break;
    case LE: fprintf(target," LE <=\n"); break;
    case GE: fprintf(target," GE >=n"); break;
    case GT: fprintf(target,"GT >\n"); break;
    case NE: fprintf(target,"NE !=\n"); break;
    case PLUS: fprintf(target,"PLUS +\n"); break;
    case MINUS: fprintf(target,"MINUS -\n"); break;
    case TIMES: fprintf(target,"TIMES *\n"); break;
    case LPAREN: fprintf(target,"LPAREN (\n"); break;
    case RPAREN: fprintf(target,"RPAREN )\n"); break;
    case SEMI: fprintf(target," SEMI ;\n"); break;
    case COMMA: fprintf(target,"COMMA ,\n"); break;
    case LBRACK: fprintf(target,"LBRACK [\n"); break;
    case RBRACK: fprintf(target,"RBRACK ]\n"); break;
    case ENDFILE: fprintf(target,"EOF\n"); break;
    case NUM:
      fprintf(target,
          "NUM %s\n",tokenString);
      break;
    case ID:
      fprintf(target,
          "ID %s\n",tokenString);
      break;
    case OVER: fprintf(target,"OVER/\n"); break;
    case LBRACE: fprintf(target," LBRACE {\n"); break;
    case RBRACE: fprintf(target," RBRACE }\n"); break;
    case ERROR:
    fprintf(target,
        "ERROR: simbolo invalido \"%s\" na linha %d\n", tokenString, lineno);
    break;
    default: /* should never happen */
      fprintf(target,"Unknown token: %d\n",token);
  }
}