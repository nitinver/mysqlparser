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

%syntax_error {  
  std::cout << "Syntax error!" << std::endl;  
}   

program ::= select_stmt(A). { 

    cout << "Parse completed.";

    PrintList(A.m_pColListHead);

    cout  << "Table = " << A.m_tableName <<  endl; 
    cout << endl;
}

select_stmt(A) ::= SELECT column_list(B) FROM table_name(C). { 

    A.m_tableName = C;
    A.m_pColListHead = B;
}

column_list(A) ::= column_name(C) COMMA column_list(B). {

 //   A = AddNode(string(C), A);
    
    A = new ListNode(string(C), B);

}

column_list(A) ::= column_name(B). {

    A = new ListNode(string(B));

 //   A = AddNode(A, string(B));
}


column_name(A) ::= NAME(B). {A = B;}

table_name(A) ::= NAME(C). {A = C;}

