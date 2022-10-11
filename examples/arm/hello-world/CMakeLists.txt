# CMake requires to set its minimum required version
cmake_minimum_required(VERSION 3.23)

# Set the project name, enabling its required languages (e.g. ASM, C and/or CXX)   
project(simpleProject LANGUAGES C)

# Add a executable target named "hello-world"
add_executable(hello-world
   # Target sources
   main.c)
   
# Set the target's compiler options
target_compile_options(hello-world PRIVATE --cpu=Cortex-M4 --fpu=VFPv4_sp --dlib_config normal)   
   
# Set the target's linker options
target_link_options(hello-world PRIVATE --semihosting --config ${TOOLKIT_DIR}/config/linker/ST/stm32f407xG.icf)

