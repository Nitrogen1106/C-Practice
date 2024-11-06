//long 型不能用于小数
#include <iostream>
const double rate1 = 0.1;
const double rate2 = 0.05;

int main()
{
    using namespace std;
    double Daphne = 100;
    double Celo = 100;

    int i = 0;
    while (Daphne >= Celo)
    {
        i = i + 1;
        Daphne = Daphne + 100 * rate1;
        Celo = Celo + Celo * rate2;
    }
    cout << "After " << i << " years Celo is richer than Daphne " << endl;
    cout << "the gap is " << (Celo - Daphne) << endl;
}