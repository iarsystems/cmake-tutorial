/**
 * @file hello.cpp
 * @brief Generic C/C++ application template
 */

#include <algorithm>
#include <array>
#include <cstdint>         // uint8_t
#include <format>          // C++20 formatting library
#include <iostream>

extern "C" {
   int foo(void);
}

int main() {
   std::array<uint8_t, 10> arr;
   std::generate(arr.begin(), arr.end(),
    []()->uint8_t { return foo(); });

   for (auto i : arr) {
      std::cout << std::format("Hello world {:02d}!\n", static_cast<int>(i));
   }

   for(;;) {
      foo(); // call a C function from C++ code
   }
}
