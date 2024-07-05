cmake_minimum_required(VERSION "3.22")

project("ncurses-demo")

#
# Generate `compile_commands.json` for `Neovim` LSP needed
#
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

#
# Compiler and flags
#
set(CMAKE_C_COMPILER "clang")
# set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_BUILD_TYPE "Release")
set(CMAKE_C_FLAGS "-pedantic-errors -ansi -Wextra -Wall -Werror -std=gnu2x")
set(CMAKE_CXX_FLAGS "-pedantic-errors -Wextra -Wall -Werror -std=gnu++20")

#
# Main exectuable
#
add_executable("${PROJECT_NAME}"
  "src/color.c"
  "src/main.c"
)

#
# Temporary testing code purpose
#
add_executable("${PROJECT_NAME}-test" "src/main_test.c")

#
# Link to `raylib`
#
# target_link_libraries("${PROJECT_NAME}" raylib)
# target_link_libraries("${PROJECT_NAME}_test" raylib)
# 
target_link_libraries("${PROJECT_NAME}" ncurses)
target_link_libraries("${PROJECT_NAME}-test" ncurses)

# target_link_libraries("copying_machine_test" pthread)


target_compile_definitions("${PROJECT_NAME}" PRIVATE ENABLE_DEBUG_LOG)

#
# Debug log
#
message(">>> CMAKE_EXPORT_COMPILE_COMMANDS: ${CMAKE_EXPORT_COMPILE_COMMANDS}")
message(">>> CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
message(">>> CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
message(">>> CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
message(">>> CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
message(">>> CMAKE_C_FLAGS_DEBUG: ${CMAKE_C_FLAGS_DEBUG}")
message(">>> CMAKE_C_FLAGS_RELEASE: ${CMAKE_C_FLAGS_RELEASE}")
message(">>> CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
message(">>> CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message(">>> CMAKE_CXX_FLAGS_DEBUG: ${CMAKE_CXX_FLAGS_DEBUG}")
message(">>> CMAKE_CXX_FLAGS_RELEASE: ${CMAKE_CXX_FLAGS_RELEASE}")
