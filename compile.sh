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
void* pParser = ParseAlloc (malloc);
Parse (pParser, SELECT, 0);
Parse (pParser, NAME, "mycol1");
Parse (pParser, COMMA, 0);
Parse (pParser, NAME, "mycol2");
Parse (pParser, COMMA, 0);
Parse (pParser, NAME, "mycol3");
Parse (pParser, FROM, 0);
Parse (pParser, NAME, "mytable");
Parse (pParser, 0, 0);
ParseFree(pParser, free );

pParser = ParseAlloc (malloc);
Parse (pParser, SELECT, 0);
Parse (pParser, NAME, "mycol1");
Parse (pParser, COMMA, 0);
Parse (pParser, NAME, "mycol2");
Parse (pParser, FROM, 0);
Parse (pParser, NAME, "mytable");
Parse (pParser, LIMIT, 0);
Parse (pParser, NUM, "10");
Parse (pParser, 0, 0);
ParseFree(pParser, free );

}

EOF

g++ -std=c++11 -ggdb select2.c -fpermissive -o select2
