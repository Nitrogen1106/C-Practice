#ifndef STOCK00_H_
#define STOCK00_H_

#include <string>
//封装的一种形式
class Stock
{
    private:               //数据原型
        std::string company;
        long shares;
        double share_val;
        double total_val;
        void set_tot() {total_val=shares*share_val;}

    public:  //友元函数 类型，程序仅能通过此部分访问对象的私有成员  ----数据隐藏
        void acquire(const std::string &co,long n,double pr);
        void buy(long num,double price);
        void sell(long num,double price);
        void update(double price);
        void show();
};


#endif