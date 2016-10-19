// cl endian.cpp /Zi /Fe:test.exe
#include <iostream>
#include <fstream>

using namespace std;
int main(const int argv, const char* args)
{
    // unsigned int i = 0x12345678;
    // unsigned long long d = 0x123456789abcdef0;
    // unsigned char p[32] = {0};
    // unsigned char p2[32] = {0};
    // memcpy(p, (void*)&i, 4);
    // memcpy(p2, (void*)&d, 8);
    // std::ofstream stream("endian.dat", ios::out|ios::binary|ios::trunc);
    // stream << p << '\0' << p2;
    // stream.close();

    union
    {
        int i;
        char x[2];
    }a;
    a.x[0] = 10;
    a.x[1] = 1;
    printf("%d",a.i);//little-endian 266 0x010a,big-endian 2561 0x0a01
    return 0;
}