//函数重载--可以有多个同名的函数
//他们完成同一工作，但是使用不同参数列表
//若参数无法完全与函数进行匹配，则会尝试进行参数转换以强制与原型函数进行匹配
//若返回类型不同，则特征标也必须不同；即函数类型不同，参数类型也必须不同

#include <iostream>
unsigned long left(unsigned long num,unsigned ct);
char *left(const char*str,int n=1);

int main()
{
    using namespace std;
    char *trip="Hawaii!!";
    unsigned long n=12345678;
    int i;
    char *temp;
    
    for(i=1;i<10;i++)
    {
        cout<<left(n,i)<<endl;
        temp=left(trip,i);
        cout<<temp<<endl;
        delete [] temp;
    }
    return 0;
}

unsigned long left(unsigned long num, unsigned ct)
{
    unsigned digit = 1;
    unsigned long n = num;

    if (ct == 0 || num == 0)
    {
        return 0;
    }
    while (n /= 10)
    {
        digit++;
    }
    if (digit > ct)
    {
        ct = digit - ct;
        while (ct--)
        {
            num /= 10;
        }
        return num;
    }
    else
        return num;
}

char *left(const char*str,int n)
{
    if(n<0)
        n=0;
    char *p=new char[n+1];
    int i;
    for(i=0;i<n && str[i];i++)
    {
        p[i]=str[i];
    }
    while(i<=n)
        p[i++]='\0';
    return p;
}
