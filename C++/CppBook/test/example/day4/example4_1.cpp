//new 创建动态数组
#include <iostream>
int main()
{
    int*psome=new int [10];
    int *pt=new int;

    //若使用new时有方括号，则最终delete时也应有方括号；反之亦然
    //此外不应用delete释放内存块两次，空指针也可以用delete释放

    delete [] psome;
    delete pt;


    return 0;
}