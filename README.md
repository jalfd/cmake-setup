# Simple script for setting up a new CMake project matching my personal and subjective preferences

To use, simply run `./deploy <dir>` or `deploy.cmd <dir>`.

This will create a CMake project in the directory specified by `<dir>`.

The project will have a basic directory structure set up for adding executables and libraries under a top-level `src` directory, a `tests` directory for tests, and a decent attempt at a sane CMake configuration.

It'll also set up vcpkg as its package manager, and install Catch2 for use in testing.

Lastly, it will also install a cmake script for creating the scaffolding for adding new libraries or executables to the project.
Simply run `cmake -DLIB=<name> -P cmake/scripts/add_target.cmake` or `cmake -DEXE=<name> -P cmake/scripts/add_target.cmake` and it will create a library or executable with the specified name.

This tool is intended to be somewhat opinionated and *just* set up everything in a way I find reasonable, but it only provides one-time defaults. Everything can be changed freely once deployed.
