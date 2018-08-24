/* Copyright (GPL) 2004 mchirico@users.sourceforge.net or mchirico@comcast.net

  Simple lemon parser  example.

  
    $ ./lemon example1.y                          

  The above statement will create example1.c.

  The command below  adds  main and the
  necessary "Parse" calls to the
  end of this example1.c.


    $ cat <<EOF >>example1.c                      
    int main()                                    
    {                                             
      void* pParser = ParseAlloc (malloc);        
      Parse (pParser, INTEGER, 1);                
      Parse (pParser, PLUS, 0);                   
      Parse (pParser, INTEGER, 2);                
      Parse (pParser, 0, 0);                      
      ParseFree(pParser, free );                  
     }                                            
    EOF                                           
            

     $ g++ -o ex1 example1.c                                      
     $ ./ex1

  See the Makefile, as most all of this is
  done automatically.
  
  Downloads:
  http://prdownloads.sourceforge.net/souptonuts/lemon_examples.tar.gz?download

*/

 
/*  
%left PLUS MINUS.   
%left DIVIDE TIMES.  
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

%type column_list {vector<string> *}

%syntax_error {  
  std::cout << "Syntax error!" << std::endl;  
}   

//program ::= select_stmt(A). { cout << "Parse completed. vec[1] = " << A.m_pvecColumns->at(0) << ", table = " << *(A.m_tableName) <<  endl; }  
program ::= select_stmt. { 
    cout << "Parse completed. col[0] = " 
         << selStmt.m_pvecColumns->at(0) << ", col[1] = " 
         << selStmt.m_pvecColumns->at(1) << "  table = " 
         << *(selStmt.m_tableName) 
         <<  endl; 

    copy(selStmt.m_pvecColumns->begin(), selStmt.m_pvecColumns->end(), ostream_iterator<string>(cout, ", "));
    cout << endl;

}  
select_stmt ::= SELECT column_list FROM table_name(C). { 

    selStmt.m_tableName = new std::string();
    *(selStmt.m_tableName) = C;
}
column_list ::= column_list COMMA column_name(A).  {
                if(selStmt.m_pvecColumns == nullptr)
                {
                    selStmt.m_pvecColumns = new vector<string>();
                }
                selStmt.m_pvecColumns->push_back(string(A));
            }
column_list ::= column_name(A). {
                if(selStmt.m_pvecColumns == nullptr)
                {
                    selStmt.m_pvecColumns = new vector<string>();
                }
                selStmt.m_pvecColumns->push_back(string(A));
            }


column_name(A) ::= NAME(B). {A = B;}
table_name(A) ::= NAME(C). {A = C;}

