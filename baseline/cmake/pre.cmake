### Set up stuff that must be done before defining the project

# The CMake Release-family of build types are a bit garbage
# Release doesn't build debug info
# RelWithDebInfo optimizes less aggressively
# MinSizeRel is pointless most of the time
# So for simplicity, define only two build types: 'debug' or 'optimized'
# 'optimized' includes full optimizations *and* debug info
# Some tools still expect the original build types to be valid, so detect those
# and fold them into either 'debug' or 'release'
set(CMAKE_CONFIGURATION_TYPES Debug Optimized)
set (VALID_BUILD_TYPES Optimized Debug Release MinSizeRel RelWithDebInfo)

# Set default build type if necessary
get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if (NOT is_multi_config)
  if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build." FORCE)
  elseif(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
    if(NOT (CMAKE_BUILD_TYPE IN_LIST VALID_BUILD_TYPES))
      message(FATAL_ERROR "Invalid build type. Must be one of ${VALID_BUILD_TYPES}")
    else()
      set(CMAKE_BUILD_TYPE "Optimized" CACHE STRING "Choose the type of build." FORCE)
    endif()
  endif()
endif()

# Tell CMake that when making Optimized builds, we should link to Release or RelWithDebInfo dependencies
set(CMAKE_MAP_IMPORTED_CONFIG_OPTIMIZED "Release;RelWithDebInfo")

enable_testing()

set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake"
  CACHE STRING "Vcpkg toolchain file")

include(GenerateExportHeader)
