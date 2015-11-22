/*
 * student number : 13331235
 * student name   : TanXiao
 * content        : regex-bison
 */

%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>

    void yyerror (char const *);

    /* Node type list */
    enum NodeType {
        Lit, Dot, Paren, Star, Plus, Quest, NgStar, NgPlus, NgQuest, Cat, Alt
    };
    char* typeStr[11] = {"Lit", "Dot", "Paren", "Star", "Plus", "Quest",
                         "NgStar", "NgPlus", "NgQuest", "Cat", "Alt"};

    /* Tree node */
    struct BiNode {
        struct BiNode* l_child;  /* Node's left child */
        struct BiNode* r_child;  /* Node's right child */
        enum NodeType _type;     /* Node type */
        char _content;           /* Node content */
    };

    /* Syntax tree */
    struct BiTree {
        struct BiNode* _root;
    };

    /* some functions */
    struct BiNode* CreateBiNode(enum NodeType, char,
                                struct BiNode*, struct BiNode*);
    void FreeTree(struct BiNode*);
    void Translate(struct BiNode*);

    /* global tree and global variable */
    struct BiTree tree;
    int ParenCount = 1;
%}

%union {
    char charType;
    struct BiNode* nodeType;
}

%token <charType> CHAR
%left  '|'

%type <nodeType> cat
%type <nodeType> alt
%type <nodeType> op
%type <nodeType> paren

%%
/* Grammar rules and actions follow.  */

input : /* empty */
      | input line
;

line  : '\n'
      | alt '\n'            {
           tree._root = $1; /* set root node. */
           Translate(tree._root);
           FreeTree(tree._root);
           tree._root = NULL;
           ParenCount = 1;
           printf("\n");
      };

/* alt: '|' */
alt   : cat                 { $$ = $1; }
      | alt '|' cat         { $$ = CreateBiNode(Alt, ' ', $1, $3); };

/* cat */
cat   : op                  { $$ = $1; }
      | cat op              { $$ = CreateBiNode(Cat, ' ', $1, $2); };

/* operators: '*' '+' '?' */
op    : paren               { $$ = $1; }
      | paren '*' '?'       { $$ = CreateBiNode(NgStar, ' ', $1, NULL); }
      | paren '+' '?'       { $$ = CreateBiNode(NgPlus, ' ', $1, NULL); }
      | paren '?' '?'       { $$ = CreateBiNode(NgQuest, ' ', $1, NULL); }
      | paren '*'           { $$ = CreateBiNode(Star, ' ', $1, NULL); }
      | paren '+'           { $$ = CreateBiNode(Plus, ' ', $1, NULL); }
      | paren '?'           { $$ = CreateBiNode(Quest, ' ', $1, NULL); };

/* paren: single char, (), (?:) */
paren : '(' alt ')'         { $$ = CreateBiNode(Paren, ' ', $2, NULL); }
      | '(' '?' ':' alt ')' { $$ = $4; }
      | CHAR                { $$ = CreateBiNode(Lit, $1, NULL, NULL); }
      | '.'                 { $$ = CreateBiNode(Dot, ' ', NULL, NULL); };

%%

int main() {
    tree._root = NULL;
    return yyparse();
}

/* Called by yyparse on error. */
void yyerror (char const *s) {
    fprintf (stderr, "%s\n", s);
}

/* Create a syntax tree node. */
struct BiNode* CreateBiNode(enum NodeType type,
                            char content,
                            struct BiNode* l,
                            struct BiNode* r) {
    struct BiNode* node = (struct BiNode*)malloc(sizeof(struct BiNode));
    node->_type = type;
    node->_content = content;
    node->l_child = l;
    node->r_child = r;
    return node;
}

/* Free the tree. */
void FreeTree(struct BiNode* subroot) {
    if (subroot) {
        FreeTree(subroot->l_child);
        FreeTree(subroot->r_child);
        free(subroot);
    }
}

/* Translate a tree node. */
void Translate(struct BiNode* node) {
    if (!node) {
        return;
    }
    printf("%s", typeStr[node->_type]);
    if (node->_type != Dot) {
        printf("(");
        if (node->_type == Lit) {
            /* print lit leaf */
            printf("%c", node->_content);
        } else if (node->_type == Paren) {
            printf("%d, ", ParenCount); /* print count */
            ParenCount++;
            Translate(node->l_child);
        } else if (node->_type == Cat || node->_type == Alt) {
            /* print 2-children node */
            Translate(node->l_child);
            printf(", ");
            Translate(node->r_child);
        } else {
            /* print 1-child node */
            Translate(node->l_child);
        }
        printf(")");
    }
}
