#include <iostream>
#include <regex>

using namespace std;

template<class T, typename C>
std::vector<T> SplitChar(T& str, C c)
{
	std::vector<T> temp;
	typedef std::basic_stringstream<C, std::char_traits<C>, std::allocator<C> > mstringstream;
	mstringstream mss;
	mss << str;
	T s;
	while (getline(mss, s, c))
	{
		temp.push_back(s);
	}
	return temp;
}

int main()
{
	std::string data = "2,1001,1,2001,10";
	std::vector<std::string> vec;
	std::regex reg(",");
	std::sregex_token_iterator it(data.begin(), data.end(), reg, -1);
	std::sregex_token_iterator end;
	while (it != end)
		vec.push_back(*it++);
	for (const std::string &str : vec)
		std::cout << str << std::endl;
	
	vec = SplitChar(data, ',');
	for (const std::string &str : vec)
		std::cout << str << std::endl;
		
	return 0;
}