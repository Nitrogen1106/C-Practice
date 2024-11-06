#ifndef WINE_H_
#define WINE_H_
#include <iostream>
#include <string>
using namespace std;
#include <valarray>

// pair类 
template <class T1,class T2>
class Pair
{
private:
    T1 year;
    T2 bottles;

public:
    Pair() {}
    Pair(const T1 &yr, const T2 &bt) : year(yr), bottles(bt) {}  //赋值
    void Set(const T1 &yr, const T2 &bt);
    int Sum() const;
    void Show(int y) const;
};

template<class T1,class T2>
void Pair<T1,T2>::Set(const T1&yr, const T2 &bt)
{
    year=yr;
    bottles=bt;
}

template<class T1,class T2>
int Pair<T1,T2>::Sum()const
{
    return bottles.sum();          //返回所有bottle的和
}

template<class T1,class T2>
void Pair<T1,T2>::Show(int y) const                   //y为几类年份
{
    for(int i=0;i<y;i++)
    {
        cout<<"year: "<<year[i]<<"bottles: "<<bottles[i]<<'\t';
    }
}

typedef valarray<int> ArrayInt;
typedef Pair<ArrayInt, ArrayInt> PairArray;

class wine
{
private:
    string wine_name;
    PairArray year_and_bottle;
    int year;
public:
    wine(const char*l,int y);
    wine(const char*l,int y,const int yr[],const int bot[]);
    string& Label();
    int sum() const;
    void GetBottles();
    void Show() const;
};


#endif