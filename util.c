/****************************************************/
/* File: util.c                                     */
/* Utility function implementation                  */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "util.h"

/* Procedure printToken prints a token 
 * and its lexeme to the listing file
 */
void printToken( TokenType token, const char* tokenString )
{ switch (token)
  { case IF:
    case THEN:
    case ELSE:
    case END:
    case REPEAT:
    case UNTIL:
    case READ:
    case WRITE:
      fprintf(target,
         "reserved word: %s\n",tokenString);
      break;
    case ASSIGN: fprintf(target,":=\n"); break;
    case LT: fprintf(target,"<\n"); break;
    case EQ: fprintf(target,"=\n"); break;
    case LPAREN: fprintf(target,"(\n"); break;
    case RPAREN: fprintf(target,")\n"); break;
    case SEMI: fprintf(target,";\n"); break;
    case PLUS: fprintf(target,"+\n"); break;
    case MINUS: fprintf(target,"-\n"); break;
    case TIMES: fprintf(target,"*\n"); break;
    case OVER: fprintf(target,"/\n"); break;
    case ENDFILE: fprintf(target,"EOF\n"); break;
    case NUM:
      fprintf(target,
          "NUM, val= %s\n",tokenString);
      break;
    case ID:
      fprintf(target,
          "ID, name= %s\n",tokenString);
      break;
    case ERROR:
    fprintf(target,
        "ERROR: símbolo inválido \"%s\"\n", tokenString);
    break;
    default: /* should never happen */
      fprintf(target,"Unknown token: %d\n",token);
  }
}