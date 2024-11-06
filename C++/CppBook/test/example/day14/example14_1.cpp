#include <vector>
#include <algorithm>
#include <iostream>
using namespace std;

void Myprint(int val)
{
   cout<<val<<endl;
}

void test01()
{
    vector<int> v;
    v.push_back(10);
    v.push_back(20);
    v.push_back(30);
    v.pop_back();

    vector<int>::iterator pBegin=v.begin();
    vector<int>::iterator pEnd=v.end();
    while(pBegin!=pEnd)
    {
        cout<<*pBegin<<endl;
        pBegin++;
    }

    for_each(v.begin(),v.end(),Myprint);
}



int main()
{
    test01();
    system("pause");
    return 0;
}