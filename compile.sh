#!/bin/bash 

./lemon select1.y

cat << EOF >> select1.c

int main()
{
void* pParser = ParseAlloc (malloc);
Parse (pParser, SELECT, "nitin");
Parse (pParser, 0, 0);
ParseFree(pParser, free );
}

EOF

g++ select1.c -fpermissive -o select1


./lemon select2.y

cat << EOF >> select2.c

int main()
{
    cout << "\n1) Parsing Query: SELECT mycol1, mycol2, mycol3 FROM mytable;\n";
    void* pParser = ParseAlloc (malloc);
    Parse (pParser, PP_TOKEN_SELECT, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mycol1");
    Parse (pParser, PP_TOKEN_COMMA, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mycol2");
    Parse (pParser, PP_TOKEN_COMMA, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mycol3");
    Parse (pParser, PP_TOKEN_FROM, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mytable");
    Parse (pParser, PP_TOKEN_SEMICOLON, "mytable");
    Parse (pParser, 0, 0);
    ParseFree(pParser, free );

    cout << "\n2) Parsing Query: SELECT mycol1, mycol2 FROM mytable LIMIT 10;\n";
    pParser = ParseAlloc (malloc);
    Parse (pParser, PP_TOKEN_SELECT, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mycol1");
    Parse (pParser, PP_TOKEN_COMMA, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mycol2");
    Parse (pParser, PP_TOKEN_FROM, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mytable");
    Parse (pParser, PP_TOKEN_LIMIT, 0);
    Parse (pParser, PP_TOKEN_NUM_INTEGER, "10");
    Parse (pParser, PP_TOKEN_SEMICOLON, "mytable");
    Parse (pParser, 0, 0);
    ParseFree(pParser, free );

    cout << "\n2) Parsing Query: SELECT mycol1, mycol2 FROM mytable WHERE mycol1 > col_value LIMIT 10;\n";
    pParser = ParseAlloc (malloc);
    Parse (pParser, PP_TOKEN_SELECT, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mycol1");
    Parse (pParser, PP_TOKEN_COMMA, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mycol2");
    Parse (pParser, PP_TOKEN_FROM, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mytable");
    Parse (pParser, PP_TOKEN_WHERE, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mycol10");
    Parse (pParser, PP_TOKEN_IDENTIFIER, ">");
    Parse (pParser, PP_TOKEN_IDENTIFIER, "col_value");
    Parse (pParser, PP_TOKEN_LIMIT, 0);
    Parse (pParser, PP_TOKEN_NUM_INTEGER, "10");
    Parse (pParser, PP_TOKEN_SEMICOLON, "mytable");
    Parse (pParser, 0, 0);
    ParseFree(pParser, free );

    cout << "Negative Tests:\n-----------------\n";
    cout << "\n1) Parsing Query: SELECT mycol1, mycol2 FROM  LIMIT 10;\n";
    pParser = ParseAlloyyc (malloc);
    Parse (pParser, PP_TOKEN_SELECT, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mycol1");
    Parse (pParser, PP_TOKEN_COMMA, 0);
    Parse (pParser, PP_TOKEN_IDENTIFIER, "mycol2");
    Parse (pParser, PP_TOKEN_FROM, 0);
    Parse (pParser, PP_TOKEN_LIMIT, 0);
    Parse (pParser, PP_TOKEN_NUM_INTEGER, "10");
    Parse (pParser, PP_TOKEN_SEMICOLON, "mytable");
    Parse (pParser, 0, 0);
    ParseFree(pParser, free );
}

EOF

g++ -std=c++11 -ggdb select2.c -fpermissive -o select2
