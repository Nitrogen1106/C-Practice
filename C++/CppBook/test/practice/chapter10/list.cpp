#include <iostream>
#include "list.h"
using namespace std;

list::list()          //创建空列表
{
    index=0;
}

void list::add_data(Item item)
{
    this->items[index++] = item;
}

void list::check_emp()
{
    if(this->index==0)
    {
        cout<<"This list is empty!"<<endl;
    }
    else
        cout<<"This empty isn't empty!"<<endl;
}

void list::check_full()
{
    if(this->index==this->MAX)
    {
        cout<<"This list is full!"<<endl;
    }
    else 
        cout<<"This list isn't full!"<<endl;
}

 void list::visit(void(*pf)(Item &))
 {
    for(int i=0;i<this->index;i++)
    {
        (*pf)(this->items[i]);
    }
 }

 void list::show_list()
 {
    for( int i=0;i<this->index;i++)
    {
        cout<<"the num of "<<this->index<<" is "<<this->items[i]<<endl;
    }
 }

 void list::create_list()
 {
        for(index;index<MAX;index++)
        {

            cout<<"please enter a number: ";
            cin>>this->items[index];
        }
        cout<<"over!"<<endl;
 }