#include <iostream>
#include <string>
using namespace std;

//可以返回引用，可以加快速度；但是不能返回临时变量，临时变量在函数运行结束后销毁

struct free_throws
{
    string name;
    int made;
    int attempts;
    float percent;
};

void display(const free_throws & ft);
void set_pc(free_throws &ft);
free_throws & accmulate(free_throws & target,const free_throws & source);

int main()
{
    free_throws one={"Isfelsa Branch",13,14};
    free_throws two={"Andor Knott",10,16};
    free_throws three={"Minnie Max",7,9};
    free_throws four={"Whily Looper",5,9};
    free_throws five={"Long Long",6,14};
    free_throws team={"Throwgoods",0,0};
    free_throws dup;

    set_pc(one);
    display(one);
    accmulate(team,one);
    display(team);

    display(accmulate(team,two));
    accmulate(accmulate(team,three),four);
    display(team);

    dup=accmulate(team,five);
    cout<<"Display team:\n";
    display(team);
    cout<<"Display dup after assignment:\n";
    display(dup);
    set_pc(four);

    accmulate(dup,five)=four;
    cout<<"Display dup after ill-advised assignment:\n";
    display(dup);
    return 0;
}

//打印数据信息
void display(const free_throws & ft)
{
    using namespace std;
    cout<<"Name: "<<ft.name<<endl;
    cout<<" Made: "<<ft.made<<"\t";
    cout<<"Attempts: "<<ft.attempts<<"\t";
    cout<<"Percent:"<<ft.percent<<endl;
}

//设置百分比
void set_pc(free_throws & ft)
{
    if(ft.attempts!=0)
    {
        ft.percent=100.0f*float(ft.made)/float(ft.attempts);
    }
    else 
        ft.percent=0;
}

//将source数据加至target中，故仅修改target的值，可将不修改的值设为const的类型
free_throws & accmulate(free_throws & target,const free_throws & source)
{
    target.attempts+=source.attempts;
    target.made+=source.made;
    set_pc(target);
    return target;
}