#include "crc32.h"

#include <stdio.h>

__root const uint32_t __checksum @ ".checksum";

// TODO 2: Change the vector size or its contents...
__root const uint8_t data[16384] = { 0 }; 

void main()
{
  // The crc32() function stops summing right before &__checksum
  uint32_t crc = crc32(0xFFFFFFFF, 0x00000000, &__checksum);

  // Print out the checksum calculated by ielftool
  printf("ielftool checksum: 0x%08X\n", __checksum);

  // Print out the checksum calculated by crc32()
  printf(" crc32() checksum: 0x%08X\n", crc);

  // Validate the checksum before
  if (crc == __checksum)
  {
    printf("    Checksum-test: PASS");
  } else {
    printf("    Checksum-test: FAIL");
    // Add countermeasures for integrity failure
  }

  // The remainder of the application...
}
