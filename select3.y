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
#include <string>
#include <stdlib.h>  
#include "select2.h"
using namespace std;
}  
   
%token_type  {char *}

%syntax_error {  
  std::cout << "Syntax error!" << std::endl;  
}   

program ::= select_stmt(A). { std::cout << "Parse completed for statement " << A << std::endl; }  
select_stmt(A) ::= SELECT column_name(B). { A = B ; cout << A << endl;}
column_name(A) ::= COLUMN_NAME(B). { A = B; }
/*
program ::= select_stmt(A). { std::cout << "Parse completed for statement " << A << std::endl; }  
select_stmt(A) ::= SELECT column_list(B) FROM table_id(C). { std::cout << "SELECT " << B << " FROM " << C << endl;  }
column_list(C) ::= column_name(D). { C = D; } 
table_id(A) := table_name(B). { A = B; }
*/
