#include <iostream>
const int Max=5;
int main()
{
    using namespace std;
    int golf[Max];
    cout << "please enter your golf scores.\n";
    cout << "You must enter " << Max << "rounds.\n";
    int i;
    for (i = 0; i < Max; i++)
    {
        cout << "round #" << i + 1 << ": ";
        while (!(cin >> golf[i]))
        {
            cin.clear();
            while (cin.get() != '\n')
            {
                continue;
            }
            cout << "please enter a number: ";
        }
    }
    double total=0.0;
    for (i=0; i < Max; i++)
    {
        total+=golf[i];
       
    }
     cout<<total/Max<<" =average score "<<Max<<"rounds\n";
    return 0;
}

//若存在输入错误，则应使用cin.clear 重置输入，否则程序会拒绝继续输入