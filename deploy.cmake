
# Require destination directory
if(NOT DEFINED DEST_DIR OR DEST_DIR STREQUAL "")
    message(FATAL_ERROR "No destination dir provided. Must be invoked with -DDEST_DIR=<name>")
endif()

# Check if destination already exists
if(EXISTS "${DEST_DIR}")
    message(FATAL_ERROR "Destination dir already exists. Aborting")
endif()

# Create destination directory
file(MAKE_DIRECTORY "${DEST_DIR}")

# Copy baseline contents
file(COPY "${CMAKE_CURRENT_LIST_DIR}/baseline/"
     DESTINATION "${DEST_DIR}")

# Helper function to run commands and fail on error
function(run_cmd)
    execute_process(
        COMMAND ${ARGV}
        RESULT_VARIABLE res
        WORKING_DIRECTORY ${DEST_DIR}
    )
    if(NOT res EQUAL 0)
        message(FATAL_ERROR "Command failed: ${ARGV}")
    endif()
endfunction()

# Initialize git repo
run_cmd(git init .)
run_cmd(git commit --allow-empty -m "Initial commit")

# Add vcpkg submodule
run_cmd(git submodule add https://github.com/microsoft/vcpkg.git)

# Update submodules
run_cmd(git submodule update --init)

# Bootstrap vcpkg
set(VCPKG_DIR "${DEST_DIR}/vcpkg")
run_cmd("${VCPKG_DIR}/bootstrap-vcpkg.sh")

# Run vcpkg commands
set(VCPKG_EXE "${VCPKG_DIR}/vcpkg")

run_cmd("${VCPKG_EXE}" new --application)
run_cmd("${VCPKG_EXE}" add port catch2)
run_cmd("${VCPKG_EXE}" add port vcpkg-cmake-config)

run_cmd(git add .)
run_cmd(git commit -m "CMake/vcpkg Scaffolding")
