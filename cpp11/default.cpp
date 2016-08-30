#include <iostream>
#include <memory>

using namespace std;

class A //: public std::enable_shared_from_this<A>
{
public:
	A(int value)
		: m_nValue(value)
	{
		cout << "A constructed " << m_nValue << endl;
	}
	virtual ~A()
	{
		cout << "A destructor " << m_nValue << endl;
	}
private:
	int m_nValue;
};

class B
{
public:
	B()
	{
		m_pA = new A(0);
		m_spA = make_shared<A>(1);
		cout << "B constructed" << endl;
	}
	~B() = default;
private:
	A* m_pA;
	shared_ptr<A> m_spA;
};

class C
{
public:
	C() 
	{
		m_pA = new A(2);
		m_spA = make_shared<A>(3);
		cout << "C constructed" << endl;
	}
	~C()
	{
		delete m_pA;
		m_spA = nullptr;
		cout << "C destructor" << endl;
	}
private:
	A* m_pA;
	shared_ptr<A> m_spA;
};

int main(int argc, char **argv)
{
	cout << "constructed" << endl;
	B* pB = new B;
	C* pC = new C;
	cout << "destructor" << endl;
	delete pB;
	delete pC;

	system("pause");
	return 0;
}