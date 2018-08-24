
#include <cstring>
#include <vector>

using namespace std;

struct SelectStatement
{
    vector<string> *m_pvecColumns;
    //char *table;

    string *m_tableName;
};

/*
void InitializeSelect(SelectStatement &A)
{
    A.m_pvecColumns = new std::vector<string>;
    A.m_tableName = new std::string();
}

void SetTableName(SelectStatement &A, string &B)
{
    A.m_tableName = B;
}
*/
