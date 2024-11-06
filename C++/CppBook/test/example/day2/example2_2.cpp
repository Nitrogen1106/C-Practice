#include <iostream>
#include <stdio.h>
#include <cstring>


int main()
{
    using namespace std;
    const int ArSize=20;
    char name[ArSize];
    char dessert[ArSize];
    
    //cin在读取输入时。输入存在空格则会停止当前读取，当存在多输入时则会导致输入读取有误
    cout<<"Enter your name: "<<endl;
    // cin>>name;
    // cin.getline(name,ArSize);
    cin.get(name,ArSize).get();

    cout<<"Enter your favorite dessert: \n";
    //cin >>dessert;
    // cin.getline(dessert,ArSize);
    cin.get(dessert,ArSize).get();

    cout << "I have some delicious "<<dessert;
    cout<< " for you, "<<name<<".\n";

    //cout.getline 每次可以读取一行，但不保存换行符。cout.get则保存换行符
    




    return 0;

}