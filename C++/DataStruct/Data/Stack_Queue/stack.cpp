#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;
//栈的常见应用：程序内存管理；浏览器的前进与后退；软件的撤销与反撤销

//------------------------------------基于链表的实现----------------------------------
//此种的效率表现更好
struct ListNode {
    int val;         // 节点值
    ListNode *next;  // 指向下一节点的指针
    ListNode(int x) : val(x), next(nullptr) {}  // 构造函数
};

class LinkListStack
{
private:
    int StackSize;
    ListNode *TopStack;
public:
    LinkListStack(){StackSize=0;TopStack=nullptr;};
    ~LinkListStack(){};
  
   //判断栈是否为空
    bool IsEmpty(){return GetSize()==0;}
    //入栈
    void Push(int x)
    {
        ListNode *node=new ListNode(x);
        node->next=TopStack;
        TopStack=node;
        StackSize++;
    }

    //返回栈顶元素
    int top()
    {
        if(IsEmpty())
            throw out_of_range("栈为空");
        return TopStack->val;
    }
    //出栈
    int Pop()
    {
        int num=top();
        ListNode *tmp=TopStack;
        TopStack=TopStack->next;
        delete tmp;
        StackSize--;
        return num;
    }

    //返回栈尺寸
    int GetSize()
    {return StackSize;}
    
    //将Stack转为Array
    vector<int> TranToVector()
    {
        ListNode *node=TopStack;
        vector<int> res(GetSize());
        for(int i=res.size();i>0;i--)
        {
            res[i]=node->val;
            node=node->next;
        }
        return res;
    }
    
};

//----------------------------------基于数组的实现---------------------------
class ArrayStack
{
private:
    vector<int> Stack;
public:
    ArrayStack();
    ~ArrayStack();

    int Top()
    {
        if(IsEmpty())
            throw out_of_range("error");
        return Stack.back();
    }
    int Size()
    {
        return Stack.size();
    }

    bool IsEmpty()
    {
        return Size()==0;
    }

    void Push(int num)
    {
        Stack.push_back(num);
    }

    int Pop()
    {
        int num=Top();
        Stack.pop_back();
        return num;
    }

    vector<int> ToVector()
    {
        return Stack;
    }
};

