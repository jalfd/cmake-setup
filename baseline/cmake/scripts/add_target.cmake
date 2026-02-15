### Helper script for creating scaffolding for a new library or executable target
### Invoke as one of:
### - cmake -DLIB=<name> -P cmake/scripts/add_target.cmake
### - cmake -DEXE=<name> -P cmake/scripts/add_target.cmake

if(NOT DEFINED EXE AND NOT DEFINED LIB)
    message(FATAL_ERROR "You must provide either -DLIB=<name> or -DEXE=<name>")
endif()

if(DEFINED EXE AND DEFINED LIB)
    message(FATAL_ERROR "You must provide only one of -DLIB=<name> and -DEXE=<name>")
endif()

if (DEFINED EXE)
set (TARGET_BASE_NAME ${EXE})
set(TARGET_FULL_NAME "${TARGET_BASE_NAME}")
else()
set (TARGET_BASE_NAME ${LIB})
set(TARGET_FULL_NAME "lib${TARGET_BASE_NAME}")
endif()

set(TARGET_PATH "${CMAKE_CURRENT_LIST_DIR}/../../src/${TARGET_FULL_NAME}")
cmake_path(NORMAL_PATH TARGET_PATH)
set(TARGET_TESTS_PATH "${CMAKE_CURRENT_LIST_DIR}/../../tests/${TARGET_FULL_NAME}")
cmake_path(NORMAL_PATH TARGET_TESTS_PATH)

if(EXISTS "${TARGET_PATH}")
    message(FATAL_ERROR "Directory ${TARGET_PATH} already exists.")
endif()
if(EXISTS "${TARGET_TESTS_PATH}")
    message(FATAL_ERROR "Directory ${TARGET_TESTS_PATH} already exists.")
endif()

# Create directories
if (DEFINED LIB)
  file(MAKE_DIRECTORY "${TARGET_PATH}/include/${TARGET_BASE_NAME}")
endif()
file(MAKE_DIRECTORY "${TARGET_PATH}/src")

file(MAKE_DIRECTORY "${TARGET_TESTS_PATH}")

if (DEFINED LIB)
# Create CMakeLists.txt
file(WRITE "${TARGET_PATH}/CMakeLists.txt"
"add_library(${TARGET_FULL_NAME} SHARED)

target_include_directories(${TARGET_FULL_NAME}
    PUBLIC
        \${OWN_INCLUDE_DIRS}
)

GENERATE_EXPORT_HEADER(${TARGET_FULL_NAME}
    EXPORT_FILE_NAME
    include/${TARGET_BASE_NAME}/export.hpp
)
if (UNIX)
  # No liblib prefix
  set_target_properties(${TARGET_FULL_NAME} PROPERTIES LIBRARY_OUTPUT_NAME ${TARGET_BASE_NAME})
endif()
")

# Create tests CMakeLists.txt
file(WRITE "${TARGET_TESTS_PATH}/CMakeLists.txt"
"add_executable(${TARGET_FULL_NAME}-test)

target_link_libraries(${TARGET_FULL_NAME}-test PRIVATE ${TARGET_FULL_NAME} Catch2::Catch2WithMain)

add_test(NAME ${TARGET_FULL_NAME}-test COMMAND ${TARGET_FULL_NAME}-test)
")

else()
# Create CMakeLists.txt
file(WRITE "${TARGET_PATH}/CMakeLists.txt"
"add_executable(${TARGET_FULL_NAME})
")

# Create tests CMakeLists.txt
file(WRITE "${TARGET_TESTS_PATH}/CMakeLists.txt"
"add_executable(${TARGET_FULL_NAME}-test)

target_link_libraries(${TARGET_FULL_NAME}-test PRIVATE Catch2::Catch2WithMain)

add_test(NAME ${TARGET_FULL_NAME}-test COMMAND ${TARGET_FULL_NAME}-test)
")
endif()


message(STATUS "Created target scaffold for target ${TARGET_BASE_NAME} at ${TARGET_FULL_NAME}")
message(STATUS "Please add `add_subdirectory(${TARGET_FULL_NAME}) to src/CMakeLists.txt and tests/CMakeLists.txt")
