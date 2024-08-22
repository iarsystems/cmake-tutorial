#ifndef _FAST_CRC32_H_
#define _FAST_CRC32_H_

#include <stdint.h>

uint32_t Fast_CRC32(uint32_t crc, uint32_t const* data, uint32_t words);

#endif /* _FAST_CRC32_H_ */