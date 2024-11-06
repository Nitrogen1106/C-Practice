#include <iostream>
#include "plorg.h"
#include <cstring>

Plorg::Plorg()   //设置默认
{
    strcpy(name, "Plorga");
}

void Plorg::report()   //汇报参数
 {
    using std::cout;
    using std::endl;
    cout<<"The name is "<<this->name<<endl;
    cout<<"The CI is "<<this->CI<<endl;
 }

void Plorg::reset_CI(int i)  //重置CI值
{
    this->CI=i;
}

void Plorg::creat_new(const char *newname) //创造新名
{
    using std::cout;
    using std::endl;
    strncpy(name,newname,19);
    this->CI=50;
}
