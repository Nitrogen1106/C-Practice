#include <stdio.h>
#include <windows.h>
#include <iostream>
#include <climits>

int main()
{
    using namespace std;
    float hats,heads;

    cout.setf(ios_base::fixed, ios_base::floatfield);   //显示全部位
    cout << "enter a number: ";
    cin >> hats;
    cout << "Enter another number: ";
    cin >> heads;

    cout << "hats= " << hats << endl;
    cout << "heads= " << heads << endl;

    cout << hats + heads << endl;
    cout << hats * heads << endl;
    cout << hats / heads << endl;

    //float 表示有效位数的能力有限，只有效保证6位
}
