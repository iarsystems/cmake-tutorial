#pragma once

typedef unsigned long uint32_t;
typedef char          uint8_t;

uint32_t crc32(uint32_t crc, uint32_t const* start_addr, uint32_t const* checksum_addr);

