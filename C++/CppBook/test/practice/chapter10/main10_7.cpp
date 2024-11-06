#include <iostream>
#include "plorg.h"

using namespace std;

int main()
{
    Plorg temp;
    temp.report();
    temp.creat_new("Betel");
    temp.report();
    temp.reset_CI(20);
    temp.report();

    return 0;
}