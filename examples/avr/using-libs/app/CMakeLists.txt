# Add the executable for the "myProgram" target,
# specifying its source files
add_executable (myProgram
  # Source files
  main.c )

# Set the properties for the "myProgram" target
set_target_properties(myProgram PROPERTIES
  XCL           "${TOOLKIT_DIR}/src/template/lnk3s.xcl" )

# Set compile options for the target
target_compile_options(myProgram PRIVATE
  $<$<COMPILE_LANGUAGE:C>:--enhanced_core -ms -y --initializers_in_flash --dlib --dlib_config ${TOOLKIT_DIR}/lib/dlib/dlAVR-3s-ec_mul-n.h>
  -v3  )

# Set the linker flags for the target
target_link_options(myProgram PRIVATE
  -rt ${TOOLKIT_DIR}/lib/dlib/dlAVR-3s-ec_mul-n.r90 
  # Set the linker script
  -f $<TARGET_PROPERTY:XCL>
  # Create a map file from the target's UBROF
  -l $<TARGET_PROPERTY:NAME>.map )

# Link "myProgram" against the "myMath" library
target_link_libraries(myProgram LINK_PUBLIC myMath)

# Optional: test the project with CTest and IAR C-SPY
include(../../iar-cspy-avr.cmake)
iar_cspy_add_test(myProgram test_add 42)
iar_cspy_add_test(myProgram test_sub 38)
iar_cspy_add_test(myProgram test_mul 80)