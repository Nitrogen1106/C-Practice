#include <iostream>
#include <string>
#include <algorithm>
#include <vector>
#include <iterator>
#include <deque>
#include <numeric>

using namespace std;

class Person
{
public:
	string m_name;
	int m_score;
	Person(string name, int score)
	{
		this->m_name = name;
		this->m_score = score;
	}

};

void create_person(vector<Person>& v)
{
	string nameSeed = "ABCDE";
	for (int i = 0; i < 5; i++)
	{
		string name = "选手";
		name += nameSeed[i];
		int score = 0;
		Person p(name, score);
		//将创建的person对象 放入到容器中
		v.push_back(p);
	}
}

void give_mark(vector<Person>& v)
{
	vector<Person>::iterator ib = v.begin();
	vector<Person>::iterator ie = v.end();
	
	for (ib; ib != ie; ib++)
	{
		cout << "please give the " << ib->m_name << " score.";
		deque<int> s;
		int o_score;
		for (int i = 0; i < 10; i++)
		{
			cin >> o_score;
			s.push_back(o_score);
		}
		sort(s.begin(), s.end());
		s.pop_front();
		s.pop_back();
		int avg = accumulate(s.begin(), s.end(), 0)/s.size();   //0为求和时的初始值
		ib->m_score = avg;
	}
}


void show_result(vector<Person>& v)
{
	cout << "The list of person :" << endl;
	vector<Person>::iterator it = v.begin();
	for (it; it != v.end(); it++)
	{
		cout << it->m_name << ":" << it->m_score << endl;
	}
}

int main()
{
	vector<Person> v;
	create_person(v);
	give_mark(v);
	show_result(v);
	return 0;
}

