#include <iostream>
int main()
{
    using namespace std;
    int nights=1001;
    int* pt=new int;
    *pt=1001;


    cout<<"night value= ";
    cout<<nights<<" :location "<<&nights<<endl;
    cout<<"int ";
    cout<<"value= "<<*pt<<":location "<<pt<<endl;
    
    double *pd=new double;
    *pd=10000001.0;

}