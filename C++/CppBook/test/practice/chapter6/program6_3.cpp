#include <iostream>

using namespace std;


int main()
{
    char ch;
    bool flag=true;
    cout<<"Please enter one of the following choices: ";
    // cout<<"c) carnivore         p) pianist"<<endl;
    // cout<<"t) tree              g)game";
    

    while(1)
{
    
    switch (cin>>ch)
    {
    case 'c':
        cout<< "carnivore";
     
        break;
    case 'p':
        cout<<"pianist";
   
        break;
    case 't':
        cout<<'tree';

        break;
    case 'g':
        cout<<'game';

        break;     
    default:
        cout<<"Please enter a c,p,t,or g: ";
        // cin>>ch;
        break;
    }
    
}
    return 0;
}