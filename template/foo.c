#include <stdint.h>

uint8_t foo(void) {
    static uint8_t i = 0;
    uint8_t res = i++;

    return res;
}
