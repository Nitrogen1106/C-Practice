#include <iostream>
double cube(double a);
double refcube(double &a);

int main()
{
    using namespace std;
    double x=3.0;

    cout<<cube(x);
    cout<<" =cube of "<<x<<endl;
    cout<<refcube(x);
    cout<<" =cube of"<<x<<endl;
    return 0;

}

double cube(double a)
{
    a*=a*a;
    return a;
}

//引用时，修改形参即修改实参
double refcube(double &ra)
{
    ra*=ra*ra;
    return ra;
}