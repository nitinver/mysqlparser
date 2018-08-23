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
#include <stdlib.h>  
#include "parsetree.h"
#include "select2.h"

using namespace std;
}  

%token_type {char *}

%default_type {char *}  

%type select_stmt {SelectStatement}

%type column_name {char *}


%syntax_error {  
  std::cout << "Syntax error!" << std::endl;  
}   

program ::= select_stmt(A). { cout << "Parse completed. vec[1] = " << A.m_pvecColumns->at(0) << ", table = " << *(A.m_tableName) <<  endl; }  
select_stmt(A) ::= SELECT column_name(B) FROM table_name(C). { 
    A.m_pvecColumns = new std::vector<string>();
    A.m_pvecColumns->push_back(string(B)); 
    
    A.m_tableName = new std::string();
    *(A.m_tableName) = C;
}
column_name(A) ::= NAME(B). {A = B;}
table_name(A) ::= NAME(C). {A = C;}

