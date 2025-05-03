# Programming Language White
## 20210808039 Derya Salihoğlu, 20210808072 Eda Dana, 20230808604 Ecenur Soybelli,20230808622 Şevval yöntem 
### BNF Grammer
---------------------------------------------------------------
// program includes at least 1 statement

`<program> ::= <function>`

// Function Definition

`<function> ::= <function> <stmt>
             | ε
             | "func" <identifier> "(" <param_list> ")" "{" <stmt_list> "}"`
// Parameter List

`<param_list> ::= <identifier>
               | <param_list> "," <identifier>
               | ε`
// Statement List

`<stmt_list> ::= <stmt>
              | <stmt_list> <stmt>`

// Statements (stmt)

`<stmt> ::= <empty_stmt>
         | <assignment_stmt>
         | <print_stmt>
         | <loop_stmt>
         | <condition_stmt>
         | <block_stmt>
         | <exception_stmt>
         | <exp> ";"`
// Empty Statement

`<empty_stmt> ::= ";"`

// Assignment Statement

`<assignment_stmt> ::= <identifier> "=" <exp> ";"`

// Print Statement

`<print_stmt> ::= "print" "(" <exp> ")" ";"`

// Block Statement

`<block_stmt> ::= "{" <stmt_list> "}"`

// Loop Statement

`<loop_stmt> ::= "while" "(" <exp> ")" <block_stmt>`

// Condition Statement 

`<condition_stmt> ::= "if" "(" <exp> ")" <block_stmt>
                   | "if" "(" <exp> ")" <block_stmt> "else" <block_stmt>`

//  Exception Statement 

`<exception_stmt> ::= "try" <block_stmt> "catch" "(" <identifier> ")" <block_stmt>`

// Expressions (exp)

`<exp> ::= <number>
        | <identifier>
        | <exp> "+" <exp>
        | <exp> "-" <exp>
        | <exp> "*" <exp>
        | <exp> "/" <exp>
        | <exp> "%" <exp>
        | <exp> "==" <exp>
        | <exp> "!=" <exp>
        | <exp> "<" <exp>
        | <exp> "<=" <exp>
        | <exp> ">" <exp>
        | <exp> ">=" <exp>
        | <exp> "&&" <exp>
        | <exp> "||" <exp>
        | "!" <exp>
        | "(" <exp> ")"`
                 
//  Identifiers and Numbers

`<identifier> ::= 'a' | 'b' | ... | 'z'
<number>     ::= [0-9]+`
                 
// Comment Statements

`<comment_stmt> ::= "~" <character>* "~"`

// Characters

`<character> ::= "'" [a-zA-Z0-9_ .,!?] "'"`
### Explanations about the White Programming Language
-------------------------------------------------------
White is a simple programming language that includes fundamental programming constructs such as variable assignments, loops, conditions, functions, and expressions. Below is a detailed explanation of its syntax and features based on its BNF grammar

***File Extension***
* White programs are written in files with the `.wt` extension

***Statements***
* 	A program consists of at least one statement.
*	A statement can be one of the following: 
       - ``Variable assignments``
	   - ``Constant definitions``
	   - ``If-else conditions``
	   - ``Loops (while)``
	   - ``Commands like print, exit, or input``

***Commands***
*  Printing:
   - `print(expression)` is used to display output.
*	Exiting:
    - The `exit` command terminates the program.
*	Taking Input:
    - `input(identifier)` is used to take user input.

***Variables and Constants***
* 	Variables are assigned using `=` and can store different data types.
*	Constants are defined using the const keyword.

***Data Types:***
   -   ``Integer:`` 123
   -  ``Identifiers:`` Variable names must start with a letter and can contain letters, numbers, and underscores

***Functions***
*	Functions are defined using the `func` keyword and can take parameters.

***Expressions and Operators***

* Arithmetic operations:
    -	``Addition (+), Subtraction (-), Multiplication (*), Division (/), Modulo (%)``

***Conditions and Comparisons***
* 	Comparison Operators:` <, >, ==, !=, <=, >=`
*	Logical Operators: `&&, ||, !`

***Blocks***
 Code blocks are enclosed in `{}` and support nested statements

***Control Flow***
* `if (a < b) {
    print(a);
    if (c > a) {
        print(c);
    } else {
        print(b);
    }
} else {
    print(b);
}`
* `while (e < 3) {
    print(e);
    b = 0;
    while (b < 2) {
        print(b);
        if (b == 1) {
            print(e + b);
        }
        b = b + 1;
    }
    e= e + 1;
}`

***Comments***
* 	Comments are written between `~...~` symbols.

***try-catch***

* `a = 10;
  b = 0;`

`try {
    c = a % b;  
    print(c);
} catch (e) {
    print(a);  
}`


 `func g() {
    a = 10;
    print(a);
}` 

`func g(a) { 
    print(a);
}`
 
***Design Decisions***
* ``Simplicity:`` Minimalist syntax inspired by C-style languages for ease of learning.
* ``Unified Expression Handling:`` Expressions support both arithmetic and logical operations uniformly.
* ``Comments:`` Chose ~ delimiters for clarity and to avoid conflict with other symbols.
* ``Exception Handling:`` Integrated try-catch mechanism to handle runtime errors.
* ``Single Entry Point:`` Program starts with function declarations, like many modern languages.
* ``File-based Execution:`` Programs are piped into the interpreter using < operator for flexibility.

***Running a White Program***
*    To compile and run a White program, use the following command:
`make ./exampleprog < example.wt `









