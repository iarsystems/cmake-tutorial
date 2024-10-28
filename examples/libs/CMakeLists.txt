cmake_minimum_required(VERSION 3.20)

project(Libs LANGUAGES C)

add_executable(libs)

target_sources(libs PRIVATE main.c)

# TODO 4: Add the `lib` subdirectory (contains the `lib` target)
add_subdirectory()

# TODO 5: Link the `lib` against `libs`
target_link_libraries()

target_compile_options(libs PRIVATE --cpu=cortex-m4)

target_link_options(libs PRIVATE
  --cpu=cortex-m4
  --semihosting)

enable_testing()

add_test(NAME libs-test
         COMMAND /opt/iarsystems/bxarm/common/bin/CSpyBat
         # C-SPY drivers for the Arm simulator via command line interface
         /opt/iarsystems/bxarm/arm/bin/libarmPROC.so
         /opt/iarsystems/bxarm/arm/bin/libarmSIM2.so
         --plugin=/opt/iarsystems/bxarm/arm/bin/libarmLibsupportUniversal.so
         # The target executable (built with debug information)
         --debug_file=$<TARGET_FILE:libs>
         # C-SPY driver options
         --backend
           --cpu=cortex-m4
           --semihosting)

set_tests_properties(libs-test PROPERTIES PASS_REGULAR_EXPRESSION "2843410253")
