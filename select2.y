/* 
    License and Copyright:  To be determined.
*/


%include {   
#include <iostream> 
#include <cstddef> 
#include <algorithm> 
#include <iterator>
#include <stdlib.h>  
#include "parsetree.h"
#include "select2.h"

using namespace std;

SelectStatement selStmt;
}  

%token_prefix PP_TOKEN_

%token_type {char *}

%default_type {char *}  

%type select_stmt {SelectStatement}

%type column_name {char *}

%type key {char *}

%type value {char *}

%type operator {char *}
%type CHAR {char *}

%type column_list {ListNode *}

%type opt_limit {int *}

%type limit_number {int}

%type opt_where {Predicate *}

%syntax_error {  
  std::cout << "Syntax error!" << std::endl;  
}   

program ::= select_stmt(A). { 

    cout << "Parse completed.";

    PrintList(A.m_pColListHead, "Columns List: ");

    cout  << "Table = " << A.m_tableName <<  endl; 

    if(A.m_pLimit != nullptr)
    {
        cout << "Limit = " << *(A.m_pLimit) << endl;
    }

    if(A.m_predicate != nullptr)
    {
        cout << "WHERE Clause Present:\n\t";
        A.m_predicate->Print();
    }

    cout << endl;
}

select_stmt(A) ::= SELECT column_list(B) FROM table_name(C) opt_where(E) opt_limit(D) SEMICOLON. { 

    A.m_tableName = C;
    A.m_pColListHead = B;
    A.m_pLimit = D;
    A.m_predicate = E;
}

column_list(A) ::= column_name(C) COMMA column_list(B). {

    A = new ListNode(string(C), B);
}

column_list(A) ::= column_name(B). {

    A = new ListNode(string(B));
}

column_name(A) ::= IDENTIFIER(B). {A = B;}

table_name(A) ::= IDENTIFIER(C). {A = C;}

opt_limit(A) ::= . {A = nullptr;} // m_pLimit will be set to nullptr;

opt_limit(A) ::= LIMIT limit_number(B). {
    A = new int;
    *A = B;
}

limit_number(A) ::= NUM_INTEGER(B). {A = atoi(B);}

opt_where(A) ::= .  {A = nullptr;} // m_predicate will be set to nullptr;

opt_where(A) ::= WHERE key(B) operator(C) value (D). {
    A = new Predicate();
    A->key = string(B);
    A->value = string(D);
    A->op = C;
}

key(A) ::= IDENTIFIER(B). {A = B;}
value(A) ::= IDENTIFIER(B). {A = B;}
operator(A) ::= IDENTIFIER(B). {A = B;}


