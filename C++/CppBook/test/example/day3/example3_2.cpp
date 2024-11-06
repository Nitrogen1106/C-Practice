//C++指针 

#include <iostream>

int main()
{
    using namespace std;
    int updates=6;
    int *p_updata;         //int* 为指针类型，表地址信息
    p_updata=&updates;       //指向updata的地址 

    cout<<"Value:updatas= "<<updates;
    cout<<",*p_updatas= "<<*p_updata<<endl;

    cout<<"Address:&updatas= "<<&updates;
    cout<<",p_updatas= "<<p_updata<<endl;

    *p_updata=*p_updata+1;  //*p_updata 提取对应元素
    cout<<"Now updatas= "<<updates<<endl;
    return 0;


    // long* fellow;
    // *fellow=2233;
    // 由于未初始化指针地址，可能导致隐性bug，同时指针非整型,可以用空指针初始化

}

