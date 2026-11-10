#ifndef UTIL_H
#define UTIL_H

void printToken(int, const char *);


TreeNode *newStmtNode(StmtKind);
TreeNode *newExpNode(ExpKind);
TreeNode *newDeclNode(DeclKind);
TreeNode *appendSibling(TreeNode *, TreeNode *);
void printTree(TreeNode *, int);

#endif
