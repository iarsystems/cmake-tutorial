include_guard()

enable_testing()

cmake_path(GET CMAKE_C_COMPILER PARENT_PATH BIN_DIR)
cmake_path(GET BIN_DIR PARENT_PATH TOOLKIT_DIR)
cmake_path(GET TOOLKIT_DIR FILENAME TOOLKIT)

# Facilitate adding C-SPY tests driven by CTest
macro(iar_cspysim TARGET PASS_REGEX)
  find_program(cspybat
    NAMES CSpyBat${CMAKE_HOST_EXECUTABLE_SUFFIX}
    HINTS ${TOOLKIT_DIR}/../common/bin
    REQUIRED
  )

  find_library(libproc
    NAMES ${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}PROC${CMAKE_SHARED_LIBRARY_SUFFIX}
          ${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}proc${CMAKE_SHARED_LIBRARY_SUFFIX}
    HINTS ${BIN_DIR}
    REQUIRED
  )
  find_library(libsim
    NAMES ${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}SIM2${CMAKE_SHARED_LIBRARY_SUFFIX}
          ${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}sim2${CMAKE_SHARED_LIBRARY_SUFFIX}
    HINTS ${BIN_DIR}
    REQUIRED
  )
  find_library(libsupportuniversal
    NAMES ${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}LibsupportUniversal${CMAKE_SHARED_LIBRARY_SUFFIX}
          ${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}libsupportuniversal${CMAKE_SHARED_LIBRARY_SUFFIX}
    HINTS ${BIN_DIR}
    REQUIRED
  )

  add_test(
    NAME ${TARGET}
    COMMAND ${cspybat} ${libproc} ${libsim}
      --plugin=${libsupportuniversal}
      --debug_file=$<TARGET_FILE:${TARGET}>
      --macro=${CMAKE_CURRENT_SOURCE_DIR}/systick.mac
      --silent
      --backend
        --cpu=cortex-m4
        --semihosting )
  # Set expected result for passing the test
  set_property(TEST ${TARGET} PROPERTY PASS_REGULAR_EXPRESSION "${PASS_REGEX}")
endmacro()
