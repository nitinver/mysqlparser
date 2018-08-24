
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

void PrintList(const ListNode *head)
{
    cout << "-------------------";
    cout << "Printing the List:";
    cout << "-------------------";

    while(head != nullptr)
    {
        cout << head->val << ", ";
        head = head->next;
    }
}

struct SelectStatement
{
    ListNode *m_pColListHead; 

    //vector<string> *m_pvecColumns;
    //char *table;

    char *m_tableName;
};

