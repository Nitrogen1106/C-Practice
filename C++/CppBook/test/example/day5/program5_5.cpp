#include <iostream>
const int year=3;
const int month=12; 
using namespace std;

int main()
{
    
    const string MonName[month] =
        {
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec"
        };
    int sum, total, sales_volume[year][month];
    for(int i=0;i<year;i++)
    {
        cout<< "Year: "<<i+1<<endl;
        for (int j=0;j<month;j++)
        {
            cout<<"Please input "<<MonName[j]<<"'s sale data"<<endl;
            cin>>sales_volume[i][j];
        }
        // total=show_result(i,sales_volume);  此部分函数尚存bug
        cout<<"this year's total sale data is "<<total;
       
    }
    
    return 0;
}

int show_result(int n,int arr[year][month])
{
    int sum=0;
    for (int m = 0; m <12; m++)
    {
       sum=sum+arr[n][m];
    }
    return sum;
}