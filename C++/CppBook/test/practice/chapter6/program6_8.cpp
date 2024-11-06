//此程序有待调试

#include <iostream>
#include <fstream>
const int Size=20;

using namespace std;

int main()
{
    char filename[Size];
    string ch;
    int i=0;
    int num=0;
    ifstream ifs;
    cout<<"Enter the name of file: "<<endl;
    cin.getline(filename,Size);
    ifs.open(filename);
    if(!ifs.is_open())
    {
        cout<<"Read file fail!"<<endl;

    }

    // 如果单纯采用isgood或者ifs的eof，会导致多读取一位，
    // peek()是文件流中用来读取文件指针下一位置的值，
    // 但指针仍然在当前位置而不是跳到一下位置
    
    while (ifs.peek()!=EOF)//如果读取成功
    {
        
        // ifs.get(filename[i]);
        ifs>>filename[i];
        i++;
        num++;
        
    }

    ifs.close();
    cout<<"This file has "<<i<<" ch";
    
    
}