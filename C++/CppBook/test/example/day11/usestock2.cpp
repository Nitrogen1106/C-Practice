#include <iostream>
#include "stock10.h"

int main()
{
    {
        using std::cout;
        cout<<"Using constructors to create new object\n";
        Stock stock1("NamoSmart",12,20.0);
        stock1.show();
        Stock stock2=Stock("Boffo Objects",2,2.0);
        stock2.show();

        
    }
}