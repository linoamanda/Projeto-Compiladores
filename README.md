# C– Compiler
Projeto da disciplina de Compiladores 2º semestre 2026 Unifesp

Linguagem: C–
Ferramentas: C, Flex e Bison

# Status do projeto

Scanner (Análise Léxica)

Implementado

* Reconhecimento de palavras reservadas, identificadores e números.
* Reconhecimento de operadores e delimitadores.
* Ignora comentários e espaços em branco.
* Implementado com Flex.

Parser (Análise Sintática)

Em desenvolvimento

* Gramática C– definida em Bison.
* Integração com o scanner.
* Pendente: construção e validação da AST.

Análise Semântica

Pendente

* Implementação da tabela de símbolos (nome, tipo e escopo).
* Verificação de declarações de variáveis e funções.
* Verificação de compatibilidade de tipos em atribuições e operações numéricas.
* Exceções: main(), input() e output().

Próximas etapas

* [ ]	Finalizar a AST.
* [ ]	Testar com o programa GCD de Louden.
* [ ]	Implementar a tabela de símbolos.
* [ ]	Implementar as verificações semânticas.
* [ ]	Testar programas válidos e inválidos.

Última atualização: Novembro de 2026.
