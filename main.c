#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "analyze.h"
#include "globals.h"
#include "scanner.h"
#include "util.h"
#include "symtab.h"
#include "parser.tab.h"



FILE *source;
FILE *target;
extern FILE *yyin;
extern int yyparse(void);

TreeNode *savedTree = NULL;
int lineno = 1;
int TraceScan = 1;

int main(int argc, char *argv[])
{
    char pgm[120];

    if (argc != 2)
    {
        fprintf(stderr, "Uso: %s <arquivo de entrada>\n", argv[0]);
        return 1;
    }

    strcpy(pgm, argv[1]);

    if (strchr(pgm, '.') == NULL)
    {
        strcat(pgm, ".c--");
    }

    source = fopen(pgm, "r");
    if (source == NULL)
    {
        fprintf(stderr, "Arquivo %s não encontrado.\n", pgm);
        exit(1);
    }
    yyin = source;

    target = fopen("saida.txt", "w");
    if (target == NULL)
    {
        fprintf(stderr, "Arquivo saida.txt não pode ser criado.\n");
        exit(1);
    }

    /* funcoes predefinidas do C-- (opcional) */
    st_insert("input",  0, TIPO_INT,  ID_FUNC, "global");
    st_insert("output", 0, TIPO_VOID, ID_FUNC, "global");

    int rc = yyparse();
    /* grava a tabela de simbolos em arquivo proprio */
    FILE *tab = fopen("tabela_simbolos.txt", "w");
    if (tab == NULL)
    {
        fprintf(stderr, "Arquivo tabela_simbolos.txt não pode ser criado.\n");
    }
    else
    {
        if (rc != 0)
         while (getToken() != 0)
             ;
        fprintf(tab, "/* AVISO: erro sintatico; tabela parcial */\n");
        printSymTab(tab);
        //fclose(tab);
        fprintf(stderr, "Tabela de simbolos gravada em tabela_simbolos.txt\n");
        fprintf(stderr, "Falha no parsing sintatico(tabela parcial).\n");
    }

    if ( rc == 0)
    {
        fprintf(stderr, "Parsing sintatico concluido com sucesso.\n\n");
        printf("Arvore sintatica:\n\n");
        printTree(savedTree, 0);
        typeCheck(savedTree);
    }
    /*else
        fprintf(stderr, "Falha no parsing sintatico(tabela parcial).\n");
*/
    

    fclose(source);
    fclose(target);
    fclose(tab);

    return 0;
}