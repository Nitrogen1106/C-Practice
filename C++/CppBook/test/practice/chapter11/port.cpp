#include <iostream>
#include "port.h"
#include <cstring>
using namespace std;


Port::Port(const char *br, const char *st, int b)
{
    brand = new char[std::strlen(br) + 1]; //new分配内存;
    std::strcpy(brand, br);
    std::strncpy(style, st, 20);
    style[19] = '\0'; //保证字符串是有效的;
    bottles = b;
}

Port::Port(const Port &p)
{
    brand=new char[strlen(p.brand)+1];
     strcpy(brand, p.brand);
    strncpy(style,p.style,20);
    style[19]='\0';
    this->bottles = p.bottles;
    cout << "Port copy constructor" << endl;
}

void Port::Show() const
{
    cout<<"Brand: "<<brand<<endl;
    cout<<"Style: "<<style<<endl;
    cout<<"Bottles: "<<bottles<<endl; 
}

Port &Port::operator=(const Port &p)
{
    if (this == &p)
    {
        return *this;
    }


        delete[] brand;
        brand = new char[strlen(p.brand) + 1];
        strcpy(brand, p.brand);
        strncpy(style, p.style, 20);
        style[19] = '\0';
        this->bottles = p.bottles;
        return *this;

}

Port &Port::operator+=(int b)
{
    bottles=bottles+b;
    return *this;
}

Port &Port::operator-=(int b)
{
    bottles=bottles-b;
    return *this;
}

ostream & operator<<(ostream &os, const Port &p)
{
    os<<p.brand<<","<<p.style<<","<<p.bottles;
    return os;
}