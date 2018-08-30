
#include <cstring>
#include <vector>

using namespace std;

struct ListNode{
    string val;
    ListNode *next;

    ListNode(const string &name): val(name), next(nullptr)
    {
    }

    ListNode(const string &name, ListNode* next): val(name), next(next)
    {
    }
};

ListNode* AddNode(ListNode *head, string name)
{
    // Set up the new node.
    ListNode *node = new ListNode(name);

    node->next = head;

    return node;
}

void PrintList(const ListNode *head, const char* msg)
{
    cout << "\n-------------------\n";
    cout << msg;
    cout << "\n-------------------\n";

    while(head != nullptr)
    {
        cout << head->val << ", ";
        head = head->next;
    }

    cout << endl;
}

/*
struct LimitClause
{
    bool m_isLimit;
    int m_numRows;
};
*/

struct Predicate
{
    string key;
    string value;
    string op;

    void Print()
    {
        cout << "Predicate: key = " << key;
        cout << ", Value = " << value;
        cout << ", op = " << op;
        cout << endl;
    }
};

struct SelectStatement
{
    ListNode *m_pColListHead; 

    char *m_tableName;

    int *m_pLimit;

    Predicate *m_predicate;
};

