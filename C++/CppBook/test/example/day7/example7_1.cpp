//读文件操作
#include <iostream>
#include <fstream>
#include <cstdlib> //support for exit()

const int Size = 60;
int main()
{
    using namespace std;
    char filename[Size];
    ifstream ifs;
    cout << "enter name of data file: ";
    cin.getline(filename, Size);
    ifs.open(filename);
    if (!ifs.is_open())
    {
        cout << "can't open the file " << filename << endl;
        cout << "Program terminating.\n";
        exit(EXIT_FAILURE);
    }

    double value;
    double sum = 0.0;
    int count = 0;
    ifs >> value;
    while (ifs.good())   //判断每次读取是否成功
    {
        ++count;
        sum += value;
        ifs >> value;
    }
    if (ifs.eof())
    {
        cout << "End of file reached!\n";
    }
    else if (ifs.fail())
    {
        cout << "Input terminated by data mismatch\n";
    }
    else
        cout << "intput terminated for unknown reason.\n";


    if (count == 0)
        cout << "No data processed!\n";
    else
    {
        cout << "Iterms read: " << count << endl;
        cout << "Sum: " << sum << endl;
        cout << "Average: " << sum / count << endl;
    }
    ifs.close();
    return 0;
}
