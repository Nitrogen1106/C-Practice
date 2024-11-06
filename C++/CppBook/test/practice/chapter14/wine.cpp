#include <iostream>
#include "wine.h"
#include <string>
using namespace std;
#include <valarray>

wine::wine(const char*l,int y)
{
    wine_name = l;
    year_and_bottle.Set(ArrayInt(y), ArrayInt(y));         //创建两数组，其中y表示大小；即几种年份
    year = y;
}

wine::wine(const char*l,int y,const int yr[],const int bot[])
{
    wine_name = l;
    year_and_bottle.Set(ArrayInt(yr,y), ArrayInt(bot,y));     //利用yr和bot初始化数组，大小为y
    year = y;
}


string& wine::Label()                       //数组名即指针
{
    return wine_name;
}

int wine::sum()const        
{
    return year_and_bottle.Sum();
}

void wine::GetBottles()
{
    ArrayInt yr(year); // year为有几个年份
    ArrayInt bt(year);

    cout << "Enter " << wine_name;
    cout << " data for " << year << " year(s):" << endl;
    for (int i = 0; i < year; i++)
    {
        cout << "Enter year: ";
        cin >> yr[i];
        cout << "Enter bottles for that year: ";
        cin >> bt[i];
    }
    year_and_bottle.Set(yr, bt);
}

void wine::Show() const
{
    cout << "Wine: " << wine_name << endl;
    cout << "\tYear\tBottles" << endl;
    year_and_bottle.Show(year);
}