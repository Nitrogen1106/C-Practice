#include <iostream>
#include "wine.h"

using namespace std;

int main()
{
    cout<<"Enter name of wine: ";
    char lab[50];
    cin.getline(lab,50);
    cout<<"Enter number of years: ";
    int yrs;
    cin>>yrs;

    wine holding(lab,yrs);
    holding.GetBottles();
    holding.Show();

    const int YRS=3;
    int y[YRS]={1993,1995,1998};
    int b[YRS]={48,60,72};
    wine more("Gushing Grape",YRS,y,b);
    more.Show();
    cout<<"Toltal bottles for "<<more.Label()<<" : "<<more.sum()<<endl;
    cout<<"Bye\n";
    return 0;
}