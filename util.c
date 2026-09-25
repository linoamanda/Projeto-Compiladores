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
         "reserved word: %s\n",tokenString);
      break;
    case EQ: fprintf(target,"==\n"); break;
    case ASSIGN: fprintf(target,"=\n"); break;
    case LT: fprintf(target,"<\n"); break;
    case LE: fprintf(target,"<=\n"); break;
    case GE: fprintf(target,">=n"); break;
    case GT: fprintf(target,">\n"); break;
    case NE: fprintf(target,"!=\n"); break;
    case PLUS: fprintf(target,"+\n"); break;
    case MINUS: fprintf(target,"-\n"); break;
    case TIMES: fprintf(target,"*\n"); break;
    case LPAREN: fprintf(target,"(\n"); break;
    case RPAREN: fprintf(target,")\n"); break;
    case SEMI: fprintf(target,";\n"); break;
    case COMMA: fprintf(target,",\n"); break;
    case LBRACK: fprintf(target,"[\n"); break;
    case RBRACK: fprintf(target,"]\n"); break;
    case ENDFILE: fprintf(target,"EOF\n"); break;
    case NUM:
      fprintf(target,
          "NUM, val= %s\n",tokenString);
      break;
    case ID:
      fprintf(target,
          "ID, name= %s\n",tokenString);
      break;
    case OVER: fprintf(target,"/\n"); break;
    case LBRACE: fprintf(target,"{\n"); break;
    case RBRACE: fprintf(target,"}\n"); break;
    case ERROR:
    fprintf(target,
        "ERROR: simbolo invalido \"%s\" na linha %d\n", tokenString, lineno);
    break;
    default: /* should never happen */
      fprintf(target,"Unknown token: %d\n",token);
  }
}