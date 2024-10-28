cmake_minimum_required(VERSION 3.20)

# TODO 1: Enable Assembly (ASM) for the project
project(Mix LANGUAGES C)

add_executable(mix)

# TODO 2: Add `fun.s` source to the `mix` target
target_sources(mix PRIVATE main.c)

target_compile_options(mix PRIVATE --cpu=cortex-m4)

target_link_options(mix PRIVATE
  --cpu=cortex-m4
  --semihosting)

enable_testing()

add_test(NAME mix-test
         COMMAND /opt/iarsystems/bxarm/common/bin/CSpyBat
         # C-SPY drivers for the Arm simulator via command line interface
         /opt/iarsystems/bxarm/arm/bin/libarmPROC.so
         /opt/iarsystems/bxarm/arm/bin/libarmSIM2.so
         --plugin=/opt/iarsystems/bxarm/arm/bin/libarmLibsupportUniversal.so
         # The target executable (built with debug information)
         --debug_file=$<TARGET_FILE:mix>
         # C-SPY driver options
         --backend
           --cpu=cortex-m4
           --semihosting)

set_tests_properties(mix-test PROPERTIES PASS_REGULAR_EXPRESSION "42")
