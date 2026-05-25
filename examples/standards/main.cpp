/**
 * @file   main.cpp
 * @brief  Demonstrates selectable C++ Standards
 */

#include <cstdint>

/**
 * @brief  The main function.
 * @param  None.
 * @retval None.
 */
int main(void)
{
  using namespace std;

  static uint_fast32_t counter = 0;

  while(true)
  {
    ++counter;
  }
}
