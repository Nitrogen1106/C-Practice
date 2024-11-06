#include <iostream>
#include "list.h"

int main()
{
    list mylist;
    mylist.create_list();
    // mylist.add_data(3);
    // mylist.add_data(5);
    mylist.show_list();
    mylist.check_emp();
    mylist.check_full();

    

    return 0;
}