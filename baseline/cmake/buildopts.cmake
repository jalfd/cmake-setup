if (${CMAKE_CXX_COMPILER_FRONTEND_VARIANT} STREQUAL "GNU")
set (FRONTEND_GNU 1)
elseif (${CMAKE_CXX_COMPILER_FRONTEND_VARIANT} STREQUAL "MSVC")
set (FRONTEND_MSVC 1)
else()
message(FATAL_ERROR "Unknown compiler frontent ${CMAKE_CXX_COMPILER_FRONTEND_VARIANT}")
endif()

if (FRONTEND_MSVC)
add_compile_options(
  # Warnings
  /W4 /WX
  # General flags
  /GF /Z7 /Zc:__cplusplus /Zc:__STDC__ /Zc:checkGwOdr /Zc:inline /Zc:templateScope /Zc:throwingNew /utf-8 /volatile:iso /permissive- /bigobj /arch:AVX2 /fp:precise /fp:contract
  # Optimization
  $<$<CONFIG:Debug>:/Os /Oi>
  $<$<CONFIG:Optimized>:/O2 /Gw /Ob3>
)
endif()

if (FRONTEND_GNU)
add_compile_options(
  # Warnings
  -Werror -pedantic-errors -Wall -Wextra -Wconversion
  # General flags
  -finput-charset=UTF-8 -g -pipe
  # Optimization
  $<$<CONFIG:Debug>:-Og>
  $<$<CONFIG:Optimized>:-O3>
)
endif()

add_compile_definitions(
  $<$<CONFIG:Optimized>:-DNDEBUG>
)

set (CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} /nologo")
