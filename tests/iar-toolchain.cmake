# Toolchain File for the IAR C/C++ Compiler

# "Generic" is used when cross compiling
set(CMAKE_SYSTEM_NAME Generic)

# Avoids running the linker during try_compile()
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

string(REGEX MATCH "[^\r\n]*" _c_compiler $ENV{C_COMPILER})
string(REGEX MATCH "[^\r\n]*" _asm_compiler $ENV{ASM_COMPILER})

set(CMAKE_C_COMPILER "${_c_compiler}")
set(CMAKE_CXX_COMPILER "${_c_compiler}")
set(CMAKE_ASM_COMPILER "${_asm_compiler}")

