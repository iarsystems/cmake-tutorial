#include <stdio.h>

#include "crc32.h"

__root const uint32_t data[4] = { 0x00010203, 0x04050607, 0x08090A0B, 0x0C0D0E0F };

void main() {
  uint32_t const * p = data;
  printf("%u\n",Fast_CRC32(0xFFFFFFFF, p, 4));
}
