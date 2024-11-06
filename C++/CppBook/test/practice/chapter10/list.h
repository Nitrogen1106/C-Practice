#ifndef LIST_H_
#define LIST_H_

typedef int Item;

class list
{
private:
    static const int MAX = 10;
    Item items[MAX];
    int index;

public:
    list();
    void add_data(Item item);
    void check_emp();
    void check_full();
    void visit(void (*pf)(Item &));
    void show_list();
    void create_list();
};

#endif