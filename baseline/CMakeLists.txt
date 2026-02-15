cmake_minimum_required(VERSION 4.2)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(pre)
project(placeholder LANGUAGES CXX VERSION 1.0.0)

include(general)
include(buildopts)
include(compat)
include(checks)

find_package(Catch2 CONFIG REQUIRED)

add_subdirectory(src)
add_subdirectory(tests)
