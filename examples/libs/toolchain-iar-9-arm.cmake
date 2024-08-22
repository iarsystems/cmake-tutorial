set(ProgramFiles "$ENV{ProgramFiles}")
set(IAR_TOOLCHAIN_ROOT "${ProgramFiles}/IAR Systems/Embedded Workbench 9.2")

find_program(CMAKE_C_COMPILER iccarm HINTS "${IAR_TOOLCHAIN_ROOT}/arm/bin")
find_program(CMAKE_CXX_COMPILER iccarm HINTS "${IAR_TOOLCHAIN_ROOT}/arm/bin")
find_program(CMAKE_ASM_COMPILER iasmarm HINTS "${IAR_TOOLCHAIN_ROOT}/arm/bin")

