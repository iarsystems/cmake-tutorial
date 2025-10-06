include_guard()

enable_testing()

# Facilitate adding C-SPY tests driven by CTest
macro(iar_cspysim TARGET)
  find_program(CSPYBAT
    NAMES CSpyBat CSpyBat.exe
    HINTS /opt/iar/cxarm /opt/iarsystems/bxarm /iar/ewarm-9.70.1
    PATH_SUFFIXES common/bin
    REQUIRED
  )
  cmake_path(GET CSPYBAT PARENT_PATH COMMON_DIR)

  find_library(LIBPROC
    NAMES libarmproc.so libarmPROC.so armproc.dll
    HINTS /opt/iar/cxarm /opt/iarsystems/bxarm /iar/ewarm-9.70.1
    PATH_SUFFIXES arm/bin
    REQUIRED
  )
  find_library(LIBSIM
    NAMES libarmsim2.so libarmSIM2.so armsim2.dll
    HINTS /opt/iar/cxarm /opt/iarsystems/bxarm /iar/ewarm-9.70.1
    PATH_SUFFIXES arm/bin
    REQUIRED
  )
  find_library(LIBSUPPORT
    NAMES libarmLibsupportUniversal.so armLibsupportUniversal.dll
    HINTS /opt/iar/cxarm /opt/iarsystems/bxarm /iar/ewarm-9.70.1
    PATH_SUFFIXES arm/bin
    REQUIRED
  )

  add_test(
    NAME ${TARGET}
    COMMAND ${CSPYBAT} ${LIBPROC} ${LIBSIM}
      --plugin=${LIBSUPPORT}
      --debug_file=$<TARGET_FILE:${TARGET}>
      --macro=${CMAKE_CURRENT_SOURCE_DIR}/systick.mac
      --silent
      --backend
        --cpu=cortex-m4
        --semihosting )
  # More than zero ticks are expected for this test
  set_property(TEST ${TARGET} PROPERTY PASS_REGULAR_EXPRESSION "ticks: ")
endmacro()
