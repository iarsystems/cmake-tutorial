# set the minimum required version of CMake to be 3.20
cmake_minimum_required(VERSION 3.20)

# set the project name
project(Tutorial)

# add the executable target
add_executable(tutorial)

# target sources
target_sources(tutorial PRIVATE tutorial.c)

# compiler options
target_compile_options(tutorial PRIVATE --debug --endian=little --cpu=Cortex-M4 -e --fpu=VFPv4_sp -Ol)

# linker options
target_link_options(tutorial PRIVATE --config ${TOOLKIT_DIR}/arm/config/linker/ST/stm32f429xI.icf --semihosting --entry __iar_program_start --vfe --text_out locale --cpu=Cortex-M4 --fpu=VFPv4_sp)

# enable testing
enable_testing()

# add a test named `tutorialTest` for `tutorial`
add_test(NAME tutorialTest
         COMMAND ${TOOLKIT_DIR}/common/bin/CSpyBat
         # C-SPY drivers for the Arm simulator via command line interface
         ${TOOLKIT_DIR}/arm/bin/libarmPROC.so
         ${TOOLKIT_DIR}/arm/bin/libarmSIM2.so
         --plugin=${TOOLKIT_DIR}/arm/bin/libarmLibsupportUniversal.so
         --device_macro=${TOOLKIT_DIR}/arm/config/debugger/ST/STM32F4xx.dmac
         # The target executable (built with debug information)
         --debug_file=$<TARGET_FILE:tutorial>
         # C-SPY driver options
         --backend
         --endian=little
        --cpu=Cortex-M4
        --fpu=VFPv4_SP
        -p
        ${TOOLKIT_DIR}/arm/config/debugger/ST/STM32F429II.ddf
        --semihosting
        --device=STM32F429II
        --multicore_nr_of_cores=1)
         
# set the `tutorialTest` test passing condition
set_tests_properties(tutorialTest PROPERTIES PASS_REGULAR_EXPRESSION "Hello world!")

