### Workarounds for platform-specific bugs

# Workaround to allow LTO to work with debug symbols MacOS
# see https://gitlab.kitware.com/cmake/cmake/-/issues/25202
if (APPLE)
add_link_options("LINKER:-object_path_lto,$<TARGET_PROPERTY:NAME>_lto.o")
add_link_options("LINKER:-cache_path_lto,${CMAKE_BINARY_DIR}/LTOCache")
endif ()

# On macos it seems we may need to run dsymutil ourselves to generate dsym symbols
# https://gitlab.kitware.com/cmake/cmake/-/issues/20256
if (APPLE)
    find_program(DSYMUTIL dsymutil)
    if (DSYMUTIL)
        foreach(var LINK_EXECUTABLE CREATE_SHARED_LIBRARY)
            LIST(APPEND CMAKE_CXX_${var} "${DSYMUTIL} <TARGET>")
        endforeach()
    endif()
endif()
