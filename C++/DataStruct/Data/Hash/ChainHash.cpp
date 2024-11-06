#include <iostream>
#include <vector>

using namespace std;


struct Pair {
  public:
    int key;
    string val;
    Pair(int key, string val) {
        this->key = key;
        this->val = val;
    }
};

class HashMapChaining
{
private:
    int size;
    int capacity;
    double loadThres;
    int extendRatio;
    vector<vector<Pair*>> buckets;

public:
    //初始化
    HashMapChaining():size(0),capacity(4),loadThres(2.0/3.0),extendRatio(2)
    {
        buckets.resize(capacity);
    }

    //析构函数
    ~HashMapChaining()
    {
        
    }
    
    //编码哈希key
    int HashFunction(int key)
    {
        return key%capacity;
    }

    //计算负载因子
    double LoadFactor()
    {
        return double(size)/double(capacity);
    }

    //检索哈希key对应值
    string GetKey(int key)
    {
        int index=HashFunction(key);
        for(Pair*pair : buckets[index])
        {
            if(pair->key==key)
            {
                return pair->val;
            }
        }
        return "No such val!";
    }

    //添加新值
    void PutVal(int key,string val)
    {
        if(LoadFactor()>loadThres)
        {
            Extend();
        }
        int index=HashFunction(key);
        for(Pair *pair:buckets[index])
        {
            if(pair->key==key)
            {
                pair->val=val;
            }
            return;
        }
        buckets[index].push_back(new Pair(key,val));
        size++;
    }

    void RemoveVal(int key)
    {
        int index=HashFunction(key);
         auto &bucket = buckets[index];
        for (int i = 0; i < bucket.size(); i++) {
            if (bucket[i]->key == key) {
                Pair *tmp = bucket[i];
                bucket.erase(bucket.begin() + i); // 从中删除键值对
                delete tmp;                       // 释放内存
                size--;
                return;
            }
        }
    }

    void Extend()
    {
        vector<vector<Pair*>> tmp=buckets;
        capacity*=extendRatio;
        buckets.clear();
        buckets.resize(capacity);
        size=0;

        for(auto &bucket : tmp)
        {
            
        }
    }

    void PrintHash()
    {
        for(auto &bucket:buckets)
        {
            for(Pair *pair:bucket)
            {
                cout<<pair->key<<"->"<<pair->val<<", ";
            }
            cout<<"\n";
        }
    }


};