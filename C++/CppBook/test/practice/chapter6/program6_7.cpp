#include <iostream>
#include <string>
#include <cctype>
using namespace std;

int main()
{
    string ch;
    cout << "Enter words (q to quit): ";
    int vowel, consonant = 0;
    int non = 0;
    while (cin >> ch && ch != "q")
    {
        if (isalpha(ch[0]))
        {
            switch (tolower(ch[0]))
            {
            case 'a':
                vowel++;
                break;
            case 'e':
                vowel++;
                break;
            case 'i':
                vowel++;
                break;
            case 'o':
                vowel++;
                break;
            case 'u':
                vowel++;
                break;
            default:
                consonant++;
                break;
            }
        }
        else
            non++;
    }

    cout<<vowel<<" words beginning with vowels."<<endl;
    cout<<consonant<<" words beginning with consonants."<<endl;
    cout<<non<<" others."<<endl;
    return 0;
}