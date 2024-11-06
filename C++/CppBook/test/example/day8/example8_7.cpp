#include <iostream>
#include <string>
using namespace std;
string version1(const string &s1, const string &s2);
const string &version2(string &s1, const string &s2);
const string &version3(string &s1, const string &s2);
int main()
{
    string input;
    string copy;
    string result;

    cout << "Entet a string: ";
    getline(cin, input);
    copy = input;
    cout << "Your string as entered: " << input << endl;

    result = version1(input, "***");
    cout << "Your string enhanced: " << result << endl;
    cout << "Your original string: " << input << endl;

    result = version2(input, "###");
    cout << "Your string enhanced: " << result << endl;
    cout << "Your original string: " << input << endl;

    cout << "Resetting original string.\n";
    input = copy;

    result = version3(input, "@@@");
    cout << "Your string enhanced: " << result << endl;
    cout << "Your original string: " << input << endl;

    return 0;
}

//此代码不改变初始值
string version1(const string &s1, const string &s2)
{
    string temp;
    temp = s2 + s1 + s2;
    return temp;
}

//此代码改变初始值
const string &version2(string &s1, const string &s2)
{
    s1 = s2 + s1 + s2;
    return s1;
}

//不可行，temp非const量，不能持续存储
const string & version3(string &s1, const string &s2)
{
    string temp;
    temp = s2 + s1 + s2;
    return temp;
}