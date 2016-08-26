#include <iostream>
#include <chrono>
#include <ctime>

using namespace std;
using namespace std::chrono;

int main()
{
	auto start = system_clock::now();

	struct tm *p;
	time_t time = std::time(nullptr);
	p = localtime(&time);
	time = mktime(p);
	
	auto end = system_clock::from_time_t(time);

	auto d = end - start;

	return 0;
}