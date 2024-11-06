#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

//---------------------基于链表实现-------------------------------
struct  ListNode
{
    int val;
    ListNode *next;
    ListNode(int x):val(x),next(nullptr){};
};

class LinkListQueue
{
private:
    int QueSize;
    ListNode *front;
    ListNode *rear;
public:
    LinkListQueue()
    {
        QueSize=0;
        front=nullptr;
        rear=nullptr;
    }
    ~LinkListQueue(){}

    int GetSize()
    {
        return QueSize;
    }

    bool IsEmpty()
    {
        return GetSize()==0;
    }

    void Push(int num)
    {
        ListNode *node=new ListNode(num);
         if (front == nullptr) 
         {
            front = node;
            rear = node;
        }
        else
        {
            rear->next=node;
            rear=node;
        }
        QueSize++;
    }
        /* 出队 */
    int pop() {
        int num = peek();
        // 删除头节点
        ListNode *tmp = front;
        front = front->next;
        // 释放内存
        delete tmp;
        QueSize--;
        return num;
    }
    /* 访问队首元素 */
    int peek() {
        if (GetSize() == 0)
            throw out_of_range("队列为空");
        return front->val;
    }

    vector<int> TranToVector()
    {
        ListNode *node=front;
        vector<int> res(GetSize());
        for(int i=0;i<res.size();i++)
        {
            res[i]=node->val;
            node=node->next;
        }
        return res;
    }
};

//---------------------------基于基础数组的队列实现--------------------------------
/* 基于环形数组实现的队列 */
class ArrayQueue {
  private:
    int *nums;       // 用于存储队列元素的数组
    int front;       // 队首指针，指向队首元素
    int queSize;     // 队列长度
    int queCapacity; // 队列容量

  public:
    ArrayQueue(int capacity) {
        // 初始化数组
        nums = new int[capacity];
        queCapacity = capacity;
        front = queSize = 0;
    }

    ~ArrayQueue() {
        delete[] nums;
    }

    /* 获取队列的容量 */
    int capacity() {
        return queCapacity;
    }

    /* 获取队列的长度 */
    int size() {
        return queSize;
    }

    /* 判断队列是否为空 */
    bool isEmpty() {
        return size() == 0;
    }

    /* 入队 */
    void push(int num) {
        if (queSize == queCapacity) {
            cout << "队列已满" << endl;
            return;
        }
        // 计算队尾指针，指向队尾索引 + 1
        // 通过取余操作实现 rear 越过数组尾部后回到头部
        int rear = (front + queSize) % queCapacity;
        // 将 num 添加至队尾
        nums[rear] = num;
        queSize++;
    }

    /* 出队 */
    int pop() {
        int num = peek();
        // 队首指针向后移动一位，若越过尾部，则返回到数组头部
        front = (front + 1) % queCapacity;
        queSize--;
        return num;
    }

    /* 访问队首元素 */
    int peek() {
        if (isEmpty())
            throw out_of_range("队列为空");
        return nums[front];
    }

    /* 将数组转化为 Vector 并返回 */
    vector<int> toVector() {
        // 仅转换有效长度范围内的列表元素
        vector<int> arr(queSize);
        for (int i = 0, j = front; i < queSize; i++, j++) {
            arr[i] = nums[j % queCapacity];
        }
        return arr;
    }
};


//--------------------------------基于动态数组的队列实现---------------------------
