/**************************************************
 *
 * Copyright (c) 2025 IAR Systems AB.
 *
 * See LICENSE for detailed license information.
 *
 **************************************************/

#include <intrinsics.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>

#define ITERATIONS 100000
#define INTERRUPT  10000

const double d_input = 2.0;
double d_result;
uint32_t ticks = 0;

void SysTick_Handler(void);
void SysTick_Handler(void) {
  ticks++;
}

void main()
{
  __enable_interrupt();

  for (uint32_t i = 0; i < ITERATIONS; i++) 
    d_result = sqrt(d_input);

  __disable_interrupt();

  printf("ticks: %u\n", ticks);
  printf("cycles: %u\n", ticks * INTERRUPT);
  printf("cycles/sqrtf(): %f\n", (float)(ticks * INTERRUPT / ITERATIONS ));
}

