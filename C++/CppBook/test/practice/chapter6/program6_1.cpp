#include <iostream>
#include <cctype>

int main()
{
  using namespace std;
  int i = 0;
  char ch[20];
  cout << "Please enter letters: ";
  cin >> ch;
  while (ch[i] != '@')
  {
    if (isalpha(ch[i]))
    {
      if (islower(ch[i]))
      {
       
        ch[i] = toupper(ch[i]);
      }
      else
      {
        ch[i]=tolower(ch[i]);
      }
      cout << ch[i];
    }

    i++;
  }
  return 0;
}