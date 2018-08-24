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

%token_type {char *}

%default_type {char *}  

%type select_stmt {SelectStatement}

%type column_name {char *}

%type column_list {ListNode *}

%type opt_limit {int *}

%type limit_number {int}



%syntax_error {  
  std::cout << "Syntax error!" << std::endl;  
}   

program ::= select_stmt(A). { 

    cout << "Parse completed.";

    PrintList(A.m_pColListHead, "Columns List: ");

    cout  << "Table = " << A.m_tableName <<  endl; 
    cout << endl;

    if(A.m_pLimit != nullptr)
    {
        cout << "Limit = " << *(A.m_pLimit) << endl;
    }
}

select_stmt(A) ::= SELECT column_list(B) FROM table_name(C) opt_limit(D). { 

    A.m_tableName = C;
    A.m_pColListHead = B;
    A.m_pLimit = D;
}

column_list(A) ::= column_name(C) COMMA column_list(B). {

    A = new ListNode(string(C), B);
}

column_list(A) ::= column_name(B). {

    A = new ListNode(string(B));
}

column_name(A) ::= NAME(B). {A = B;}

table_name(A) ::= NAME(C). {A = C;}

opt_limit(A) ::= . {A = nullptr;}

opt_limit(A) ::= LIMIT limit_number(B). {
    A = new int;
    *A = B;
}

limit_number(A) ::= NUM(B). {A = atoi(B);}


