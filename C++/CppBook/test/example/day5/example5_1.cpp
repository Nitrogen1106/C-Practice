//编写延时，该程序以系统时间单位为单位，而非秒为单位


#include <iostream>
#include <ctime>
int main()
{
    using namespace std;
    cout << "Enter the delay time,in seconds: ";
    float secs;
    cin>>secs;
    clock_t delay=secs*CLOCKS_PER_SEC;
    cout<<"Starting\a\n";
    clock_t start=clock();   //获取当前CPU时间并存入start变量中
    while (clock()-start<delay);

    cout<<"done \a\n";
    return 0;
    

}