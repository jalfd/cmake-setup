# FIXME: only do this once
include(CheckCXXSourceCompiles)
check_cxx_source_compiles("int main(){}" CAN_COMPILE_CXX)
if (NOT CAN_COMPILE_CXX)
    message(FATAL_ERROR "Failed to compile a minimal C++ project")
endif()
