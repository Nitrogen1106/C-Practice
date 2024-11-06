#include <iostream>
#include <string>
using namespace std;
const int strsize = 20;
const int Num = 5;

struct bop
{
    char fullname[strsize];
    char title[strsize];
    char bopname[strsize];
    int preference;
};

void show_menu();

int main()
{
    int num;
    char ch;
    bop data[Num] =
        {
            {"Wimp Macho", "Teacher", "WMA", 0},
            {"Raki Rhodes", "Junior Programmer", "RHES", 1},
            {"Celia Laiter", "Professor", "MIPS", 2},
            {"Hoppy Hipman", "Analyst Trainee", "HPAN", 1},
            {"Pat Hand", "Animal Keeper", "LOOPY", 2},

        };

    show_menu();
    cout << "Enter your choice: ";

    while (cin >> ch && ch != 'q')
    {
        switch (ch)
        {
        case 'a':
            for (int i = 0; i < 5; i++)
            {
                cout << data[i].fullname << endl;
            }
            break;
        case 'b':
            for (int i = 0; i < 5; i++)
            {
                cout << data[i].title << endl;
            }
            break;
        case 'c':
            for (int i = 0; i < 5; i++)
            {
                cout << data[i].bopname << endl;
            }
            break;
        case 'd':
            cout << "Enter a num from 0 to 2: ";
            cin >> num;
            switch (num)
            {
            case 0:
                for (int i = 0; i < 5; i++)
                {
                    cout << data[i].fullname << endl;
                }

                break;
            case 1:
                for (int i = 0; i < 5; i++)
                {
                    cout << data[i].title << endl;
                }

                break;
            case 2:
                for (int i = 0; i < 5; i++)
                {
                    cout << data[i].bopname << endl;
                }

                break;

            default:
                break;
            }

            break;
        case 'q':
            cout << "bye!" << endl;
            break;

        default:
            cout << "Illegal input!" << endl;
            break;
        }
    }
}

void show_menu()
{
    cout << "Benevolent Order of Programmers Report" << endl;
    cout << "a. display by name     b. display by title" << endl;
    cout << "c. display by bopname  d. display by preference" << endl;
    cout << "q. quit" << endl;
}