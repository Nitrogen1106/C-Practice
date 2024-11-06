#include <iostream>
#include <cstring>
#include "vintageport.h"
#include "port.h"
using namespace std;


//构造函数初始化
VintagePort::VintagePort():Port("none","vintage",0)
{
    nickname=new char[1];
    nickname[0]='\0';
    year=0;
}


 VintagePort::VintagePort(const char*br,int b,const char*nn,int y):Port(br,"vintage",b)
 {
    nickname=new char[strlen(nn)+1];
    strcpy(nickname,nn);
    year=y;
 }

//显式初始化
 VintagePort::VintagePort(const VintagePort &vp):Port(vp)
 {
    nickname=new char[strlen(vp.nickname)+1];
    strcpy(nickname,vp.nickname);
    year=vp.year;
 }

 VintagePort &VintagePort::operator=(const VintagePort &vp)
 {
     if (this == &vp)
     {
         return *this;
     }

     delete[] nickname;
     Port::operator=(vp);
     nickname=new char[strlen(vp.nickname)+1];
     strcpy(nickname,vp.nickname);
     year=vp.year;
     return *this;

 }

 void VintagePort::Show() const
 {
    Port::Show();
    cout<<"Nickname: "<<nickname<<endl;
    cout<<"Year: "<<year<<endl;
 }

 ostream &operator<<(ostream &os,const VintagePort &vp)
 {
    os<<(const Port&)vp;
    os<<","<<vp.nickname<<","<<vp.year<<endl;
    return os;
 }

 