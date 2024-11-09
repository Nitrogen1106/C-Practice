#include <iostream>
#include <vector>
#include <string>
using namespace std;

struct  Pair
{
public:
    int key;
    string val;

public:
    Pair(int key,string val)
    {
        this->key=key;
        this->val=val;
    }
};

/* 开放寻址哈希表 */
class HashMapOpenAddressing {
  private:
    int size;                             // 键值对数量
    int capacity = 4;                     // 哈希表容量
    const double loadThres = 2.0 / 3.0;     // 触发扩容的负载因子阈值
    const int extendRatio = 2;            // 扩容倍数
    vector<Pair *> buckets;               // 桶数组
    Pair *TOMBSTONE = new Pair(-1, "-1"); // 删除标记

  public:
    /* 构造方法 */
    HashMapOpenAddressing() : size(0), buckets(capacity, nullptr) {
    }

    /* 析构方法 */
    ~HashMapOpenAddressing() {
        for (Pair *pair : buckets) {
            if (pair != nullptr && pair != TOMBSTONE) {
                delete pair;
            }
        }
        delete TOMBSTONE;
    }

    /* 哈希函数 */
    int hashFunc(int key) {
        return key % capacity;
    }

    /* 负载因子 */
    double loadFactor() {
        return (double)size / capacity;
    }

    /* 搜索 key 对应的桶索引 */
    int findBucket(int key) {
        int index = hashFunc(key);
        int firstTombstone = -1;
        // 线性探测，当遇到空桶时跳出
        while (buckets[index] != nullptr) {
            // 若遇到 key ，返回对应的桶索引
            if (buckets[index]->key == key) {
                // 若之前遇到了删除标记，则将键值对移动至该索引处
                if (firstTombstone != -1) {
                    buckets[firstTombstone] = buckets[index];
                    buckets[index] = TOMBSTONE;
                    return firstTombstone; // 返回移动后的桶索引
                }
                return index; // 返回桶索引
            }
            // 记录遇到的首个删除标记
            if (firstTombstone == -1 && buckets[index] == TOMBSTONE) {
                firstTombstone = index;
            }
            // 计算桶索引，越过尾部则返回头部
            index = (index + 1) % capacity;
        }
        // 若 key 不存在，则返回添加点的索引
        return firstTombstone == -1 ? index : firstTombstone;
    }

    /* 查询操作 */
    string get(int key) {
        // 搜索 key 对应的桶索引
        int index = findBucket(key);
        // 若找到键值对，则返回对应 val
        if (buckets[index] != nullptr && buckets[index] != TOMBSTONE) {
            return buckets[index]->val;
        }
        // 若键值对不存在，则返回空字符串
        return "";
    }

    /* 添加操作 */
    void put(int key, string val) {
        // 当负载因子超过阈值时，执行扩容
        if (loadFactor() > loadThres) {
            extend();
        }
        // 搜索 key 对应的桶索引
        int index = findBucket(key);
        // 若找到键值对，则覆盖 val 并返回
        if (buckets[index] != nullptr && buckets[index] != TOMBSTONE) {
            buckets[index]->val = val;
            return;
        }
        // 若键值对不存在，则添加该键值对
        buckets[index] = new Pair(key, val);
        size++;
    }

    /* 删除操作 */
    void remove(int key) {
        // 搜索 key 对应的桶索引
        int index = findBucket(key);
        // 若找到键值对，则用删除标记覆盖它
        if (buckets[index] != nullptr && buckets[index] != TOMBSTONE) {
            delete buckets[index];
            buckets[index] = TOMBSTONE;
            size--;
        }
    }

    /* 扩容哈希表 */
    void extend() {
        // 暂存原哈希表
        vector<Pair *> bucketsTmp = buckets;
        // 初始化扩容后的新哈希表
        capacity *= extendRatio;
        buckets = vector<Pair *>(capacity, nullptr);
        size = 0;
        // 将键值对从原哈希表搬运至新哈希表
        for (Pair *pair : bucketsTmp) {
            if (pair != nullptr && pair != TOMBSTONE) {
                put(pair->key, pair->val);
                delete pair;
            }
        }
    }

    /* 打印哈希表 */
    void print() {
        for (Pair *pair : buckets) {
            if (pair == nullptr) {
                cout << "nullptr" << endl;
            } else if (pair == TOMBSTONE) {
                cout << "TOMBSTONE" << endl;
            } else {
                cout << pair->key << " -> " << pair->val << endl;
            }
        }
    }
};


int main()
{
    HashMapOpenAddressing hash;

    // 测试插入操作
    hash.put(1, "one");
    hash.put(2, "two");
    hash.put(3, "three");
    hash.put(4, "four");

    // 测试查询操作
    cout << "Testing get operations:" << endl;
    cout << "Key 1: " << hash.get(1) << endl; // 应输出 "one"
    cout << "Key 2: " << hash.get(2) << endl; // 应输出 "two"
    cout << "Key 3: " << hash.get(3) << endl; // 应输出 "three"
    cout << "Key 4: " << hash.get(4) << endl; // 应输出 "four"
    cout << "Key 5: " << hash.get(5) << endl; // 应输出 ""

    // 测试删除操作
    hash.remove(2);
    cout << "After removing key 2:" << endl;
    cout << "Key 2: " << hash.get(2) << endl; // 应输出 ""

    // 测试扩容操作
    hash.put(5, "five");
    hash.put(6, "six");
    hash.put(7, "seven");
    hash.put(8, "eight");
    hash.put(9, "nine");

    cout << "After extending the hash map:" << endl;
    cout << "Key 5: " << hash.get(5) << endl; // 应输出 "five"
    cout << "Key 6: " << hash.get(6) << endl; // 应输出 "six"
    cout << "Key 7: " << hash.get(7) << endl; // 应输出 "seven"
    cout << "Key 8: " << hash.get(8) << endl; // 应输出 "eight"
    cout << "Key 9: " << hash.get(9) << endl; // 应输出 "nine"

    // 打印哈希表
    cout << "Final state of the hash map:" << endl;
    hash.print();

    return 0;
}