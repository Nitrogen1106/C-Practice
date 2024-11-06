#ifndef PLORG_H_
#define PLORG_H_

class Plorg
{
private:
    char name[20];
    int CI;

public:
    Plorg();
    void report();   //汇报参数
    void reset_CI(int i);  //重置CI值
    void creat_new(const char *newname); //创造新名

};

#endif