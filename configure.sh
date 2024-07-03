#!/bin/sh

#
# Remove everything exists
#
rm -rf build temp_build

#
# Run cmake to generate all files
#
LLVM_CLANG=$(which clang)
cmake -S ./ -B ./temp_build -DCMAKE_C_COMPILER="${LLVM_CLANG}"

#
# Copy `compile_commands.json` to `build/compile_commands.json` for `clangd` LSP backend
#
mkdir build
cp -rvf ./temp_build/compile_commands.json ./build
