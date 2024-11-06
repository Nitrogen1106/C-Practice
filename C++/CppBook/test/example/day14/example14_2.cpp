#include <vector>
#include <iostream>
#include <string>

using namespace std;

class Person
{
public:
    string mName;
    int mAge;
    Person(string name,int age)
    {
        mName=name;
        mAge=age;
    }
};

void test01()
{
    vector<Person> v;
    Person p1("aaa", 10);
    Person p2("bbb", 20);
    Person p3("ccc", 30);
    Person p4("ddd", 40);
    Person p5("eee", 50);

    v.push_back(p1);
    v.push_back(p2);
    v.push_back(p3);
    v.push_back(p4);
    v.push_back(p5);

    for(vector<Person>::iterator it=v.begin();it!=v.end();it++)
    {
        cout<<"Name:"<<(*it).mName<<" Age:"<<(*it).mAge<<endl;
    }
}

void test02()
{
    vector<Person*> v;
    Person p1("aaa", 10);
    Person p2("bbb", 20);
    Person p3("ccc", 30);
    Person p4("ddd", 40);
    Person p5("eee", 50);

    v.push_back(&p1);
    v.push_back(&p2);
    v.push_back(&p3);
    v.push_back(&p4);
    v.push_back(&p5);

    for(vector<Person*>::iterator it=v.begin();it!=v.end();it++)
    {
        Person* p=(*it);
        cout<<"Name:"<<p->mName<<" Age:"<<p->mAge<<endl;
    }
}

int main()
{
    void test02();
    system("pause");

    return 0;
}