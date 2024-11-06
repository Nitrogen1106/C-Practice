#include <iostream>
int main()
{
    using namespace std;
    double *p3 = new double[3];
    p3[0] = 0.2;
    p3[1] = 0.5;
    p3[2] = 0.8;
    cout << p3[1] << endl;
    p3 = p3 + 1;
    cout << p3[0] << endl;
    cout << p3[1] << endl;
    cout << p3[2];
    p3 = p3 - 1;

    delete[] p3;
    return 0;

    //strcpy赋值后会开辟新地址，区别于指针赋值
    //此外应使用strcpy和strncpy将字符串赋给数组，而非使用=号
    //<<运算符的优先级更高
    //cout.setf(ios_base::boolalpha)可以让cout显示ture 和false，而非0和1；
}
