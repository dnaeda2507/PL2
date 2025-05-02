%{ 
#include <stdio.h>
#include <stdlib.h>
 #include <stdarg.h>
 #include "node.h"
 
 #include <setjmp.h>

jmp_buf jumpBuffer;
int exceptionThrown = 0;


nodeType *con(int value);
nodeType *id(int i);
nodeType *opr(int oper, int nops, ...);
void freeNode(nodeType *p);
int ex(nodeType *p);

int yylex(void);
void yyerror(char *s);


int sym[26]; 
%}

%union {
    int num;                 
    char id;               
    nodeType *nPtr;             
};





%left OR
%left AND
%left EQ NE
%left LT LE GT GE
%left '+' '-'
%left '*' '/' '%'
%right NOT


%token <num> number
%token <id> identifier
%token IF ELSE WHILE print
%token EXIT INPUT FUNC RETURN  TRY CATCH
%token TRUE FALSE COMMA FOR
%token EQ NE LT LE GT GE AND OR NOT



%nonassoc IFX
%nonassoc ELSE

%type <nPtr> stmt exp stmt_list

%%

program:
        function                { exit(0); }
        ;

function:
          function stmt         { ex($2); freeNode($2); }
        |FUNC identifier '('param_list ')' '{' stmt_list '}'  
        |
        ;

 param_list:
    identifier 
    | param_list COMMA identifier 
    |
    ;


stmt:    
     ';'                               { $$ = opr(';', 2, NULL, NULL); }
    | exp ';' { $$ = $1; }
    | identifier '=' exp';'            { $$ = opr('=', 2, id($1), $3); }         
    | print '(' exp ')' ';'                  { $$ = opr(print, 1, $3); }
    | WHILE '(' exp ')' '{' stmt_list '}'          { $$ = opr(WHILE, 2, $3, $6); }

    | IF '(' exp ')' '{' stmt_list '}'  %prec IFX   { $$ = opr(IF, 2, $3, $6); }
    | IF '(' exp ')' '{' stmt_list '}' ELSE '{' stmt_list '}'  
       { $$ = opr(IF, 3, $3, $6, $10); }
    | '{'  stmt_list  '}'             { $$ = $2; }
    | TRY '{' stmt_list '}' CATCH '(' identifier ')' '{' stmt_list '}' {
        $$ = opr(TRY, 3, $3, id($7), $10);
    }
    
    ;

stmt_list:
          stmt                  { $$ = $1; }
        | stmt_list stmt        { $$ = opr(';', 2, $1, $2); }
        ;

exp
    : number                      { $$ = con($1); }
    | identifier                  { $$ = id($1); }
    | exp '+' exp                 { $$ = opr('+', 2, $1, $3); }
    | exp '-' exp                 { $$ = opr('-', 2, $1, $3); }
    | exp '*' exp                 { $$ = opr('*', 2, $1, $3); }
    | exp '/' exp                 { $$ = opr('/', 2, $1, $3); }
    | exp '%' exp                 { $$ = opr('%', 2, $1, $3); }
    | exp EQ exp                  { $$ = opr(EQ,  2, $1, $3); }
    | exp NE exp                  { $$ = opr(NE,  2, $1, $3); }
    | exp LT exp                  { $$ = opr(LT,  2, $1, $3); }
    | exp LE exp                  { $$ = opr(LE,  2, $1, $3); }
    | exp GT exp                  { $$ = opr(GT,  2, $1, $3); }
    | exp GE exp                  { $$ = opr(GE,  2, $1, $3); }
    | exp AND exp                 { $$ = opr(AND, 2, $1, $3); }
    | exp OR exp                  { $$ = opr(OR,  2, $1, $3); }
    | NOT exp                     { $$ = opr(NOT, 1, $2); }
    | '(' exp ')'                 { $$ = $2; }
    ;





%%
#define SIZEOF_NODETYPE ((char *)&p->con - (char *)p) 

nodeType *con(int value) {
    nodeType *p;


    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");


    p->type = typeCon;
    p->con.value = value;

    return p;
}


nodeType *id(int i) {
    nodeType *p;


    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");


    p->type = typeId;
    p->id.i = i;

    return p;
}

nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    int i;


    if ((p = malloc(sizeof(nodeType))) == NULL)
 yyerror("out of memory");
 if ((p->opr.op = malloc(nops * sizeof(nodeType))) == NULL)
 yyerror("out of memory");

    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}

void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOpr) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
    }
    free (p);
}

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
 yyparse();
 return 0;
} 


int ex(nodeType *p) {
    if (!p) return 0;
    switch(p->type) {
    case typeCon:       return p->con.value;
    case typeId:        return sym[p->id.i];
    case typeOpr:
        switch(p->opr.oper) {
        case WHILE:     while(ex(p->opr.op[0])) ex(p->opr.op[1]); return 0;
        case IF:        if (ex(p->opr.op[0]))
                            ex(p->opr.op[1]);
                        else if (p->opr.nops > 2)
                            ex(p->opr.op[2]);
                        return 0;
        case print:     printf("%d\n", ex(p->opr.op[0])); 
        return 0;

        case ';': ex(p->opr.op[0]); 
            return ex(p->opr.op[1]); 

        case '=': 
            return sym[p->opr.op[0]->id.i] =ex(p->opr.op[1]);
        case '+':
            return ex(p->opr.op[0]) + ex(p->opr.op[1]);
        case '-':
           return ex(p->opr.op[0]) - ex(p->opr.op[1]);
        case '*':
          return ex(p->opr.op[0]) * ex(p->opr.op[1]);
       case '/':
            if (ex(p->opr.op[1]) == 0) {
                yyerror("Division by zero, jumping to catch block");
                exceptionThrown = 1;
                longjmp(jumpBuffer, 1);
            }
            return ex(p->opr.op[0]) / ex(p->opr.op[1]);

    
        case '%':
            if (ex(p->opr.op[1]) == 0) {
               yyerror("Modulo by zero, jumping to catch block");
                exceptionThrown = 1;
                longjmp(jumpBuffer, 1);
            }
            return ex(p->opr.op[0]) % ex(p->opr.op[1]);
        case EQ:
            return ex(p->opr.op[0]) == ex(p->opr.op[1]);
        case NE:
           return ex(p->opr.op[0]) != ex(p->opr.op[1]);
        case LT:
            return ex(p->opr.op[0]) < ex(p->opr.op[1]);
        case LE:
            return ex(p->opr.op[0]) <= ex(p->opr.op[1]);
        case GT:
            return ex(p->opr.op[0]) > ex(p->opr.op[1]);
        case GE:
            return ex(p->opr.op[0]) >=  ex(p->opr.op[1]);

        case AND:
           return ex(p->opr.op[0]) && ex(p->opr.op[1]);
        case OR:
            return ex(p->opr.op[0]) || ex(p->opr.op[1]);
        case NOT:
            return !ex(p->opr.op[0]);
        case TRY: {
            int result;
            exceptionThrown = 0;

            if (setjmp(jumpBuffer) == 0) {
                // try bloğunu çalıştır
                result = ex(p->opr.op[0]);
            } else {
                // exception oldu, catch bloğunu çalıştır
                result = ex(p->opr.op[2]);
            }

            return result;
        }
    
        }
    }

    /* Hiçbir şeye uymadıysa 0 döner */
    return 0;
}



