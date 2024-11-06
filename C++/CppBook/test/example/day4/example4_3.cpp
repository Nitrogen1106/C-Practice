//1.const和#define的区别：const定义附带对应类型，而#define则不会，可能导致后续运算错误
//2.using声明和using编译指令的区别：using编译指令为全局指令

#include <iostream>
#include <string>

//倒序输出
int main()
{
    using namespace std;
    cout << "Enter a word: " << endl;
    string word;
    cin >> word;
    int num = word.size() / 2;
    int size = word.size() - 1;

    for (int i = 0; i < num; i++)
    {
        char temp;
        temp = word[i];
        word[i] = word[size - i];
        word[size - i] = temp;
    }

    cout << word;

    return 0;


   


}