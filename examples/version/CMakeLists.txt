cmake_minimum_required(VERSION 3.20)

# TODO 1: Add the `project()`'s `VERSION` and set it to `2.7.1`
project(Project LANGUAGES C)

add_executable(version)

target_sources(version PRIVATE main.c)

# TODO 2: Configure `version.h.in` to generate `version.h`
configure_file()

# TODO 3: Add the Project Binary Directory to the target's include directories
target_include_directories()

target_link_options(version PRIVATE --semihosting)

enable_testing()

add_test(NAME version-test
         COMMAND /opt/iarsystems/bxarm/common/bin/CSpyBat
         # C-SPY drivers for the Arm simulator via command line interface
         /opt/iarsystems/bxarm/arm/bin/libarmPROC.so
         /opt/iarsystems/bxarm/arm/bin/libarmSIM2.so
         --plugin=/opt/iarsystems/bxarm/arm/bin/libarmLibsupportUniversal.so
         # The target executable (built with debug information)
         --debug_file=$<TARGET_FILE:version>
         # C-SPY driver options
         --backend
           --cpu=cortex-m4
           --semihosting)

set_tests_properties(version-test PROPERTIES PASS_REGULAR_EXPRESSION "2.7.1")
