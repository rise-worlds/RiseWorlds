#include <iostream>
#include <chrono>
#include <ctime>

using namespace std;
using namesapce std::chrono;

int main()
{
	auto start = system_clock::now();

	struct tm *p;
	time_t time = time(nullprt);
	p = localtime(&time);
	time = mktime(p);
	
	auto end = system_clock::from_time_t(time);

	duration d = end - start;

	return 0;
}