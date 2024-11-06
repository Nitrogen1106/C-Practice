//函数模板
template <typename AnyType>    //template类型
void Swap(AnyType &a,AnyType &b)
{
    AnyType temp;
    temp=a;
    a=b;
    b=temp;
}



//显式具体化 --选取时优先于模板函数
struct  job
{
    char name[40];
    double salary;
    int floor;
};

void Swap(job &, job &);
template <> void Swap<job>(job &, job &);
template <> void Swap(job &,job &);   //与上述同理

