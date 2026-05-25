cmake_minimum_required(VERSION 4.1.2)

project(custom)

# TODO 1: Include CMake modules to the project
list()
include()
include()

# Enable IAR Language Extensions
set(C_EXTENSIONS ON)

# Add multiple executables
add_executable(sqrt_test)
add_executable(sqrtf_test)

target_sources(sqrt_test PRIVATE
  sqrt.c
)

target_sources(sqrtf_test PRIVATE
  sqrtf.c
)

# Set multiple target properties at once
set_target_properties(
  sqrt_test
  sqrtf_test
  PROPERTIES
    COMPILE_OPTIONS --cpu=cortex-m4
    LINK_OPTIONS --semihosting
)

# Add simulated tests
iar_cspysim(sqrt_test "ticks:")
iar_cspysim(sqrtf_test "ticks:")
