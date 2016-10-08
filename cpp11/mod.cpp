#include <iostream>

int main(int argv, const char* args)
{
    int max_size = 25;
    std::cin >> max_size;
    int i = 0, size = 0;
    while (true)
    {
        if (i == 0)
        {
            if (max_size / 10)
                size = 10;
            else
                size = max_size % 10;
            std::cout << size << std::endl;
        }
        std::cout << ++i << " ";
        if (i == size)
        {
            i = 0;
            max_size -= size;
            std::cout << std::endl;
            if (size < 10)
                break;
        }
    }
    // max_size = 25;
    // std::cin >> max_size;
    // i = 0;
    // while(true)
    // {
    //     if ((i % 10) == 0)
    //     {
    //         if ((max_size - i) / 10)
    //             size = 10;
    //         else
    //             size = max_size % 10;
            
    //         std::cout << std::endl << size << std::endl;
    //     }
    //     std::cout << ++i << " ";
    //     if (i == max_size)
    //     {
    //         break;
    //     }
    // }
    return 0;
}