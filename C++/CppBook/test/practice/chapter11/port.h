#ifndef PORT_H_
#define PORT_H_
#include <iostream>
using namespace std;

class Port
{
private:
	char *brand;
	char style[20];
	int bottles;
public:
	Port(const char *br = "none", const char *st = "none", int b = 0);
	Port(const Port &p);   //拷贝
	
	virtual ~Port() {delete [] brand;};   //虚析构函数
	Port &operator=(const Port &p); 	  //重载运算符
	Port &operator+=(int b);				
	Port &operator-=(int b);

    int BottoleCount() const {return bottles;};		//返回瓶子数
    virtual void Show() const;					//展示
    friend ostream & operator<<(ostream &os, const Port &p);	//友元调用
    	
};

#endif
