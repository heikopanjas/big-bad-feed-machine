#!/bin/bash

################################################################################
#
# Copyright (c) ultralove contributors (https://github.com/ultralove)
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
################################################################################

BUILD_CONFIGURATION="Debug"
BUILD_PRODUCT_DIRECTORY="_build"
BUILD_ARTIFACTS="$BUILD_PRODUCT_DIRECTORY/artifacts"
BUILD_CLEAN=0
BUILD_RESET=0
BUILD_REBUILD=0
BUILD_SHARED="ON"
BUILD_INSTALL=0
BUILD_UNINSTALL=0
BUILD_PACKAGE=0

CMAKE_BUILD_ARGS=""
CMAKE_GENERATOR="Ninja"
CMAKE_INSTALL_FOUND=0
CMAKE_INSTALL_PATH=cmake
CMAKE_REQUIRED_VERSION="3.28"

source "scripts/buildtools.sh"

for arg in "$@"
do
case $arg in
    --clean)
    BUILD_CLEAN=1
    shift
    ;;
    --cleanall)
    BUILD_RESET=1
    shift
    ;;
    -c=*|--config=*)
    BUILD_CONFIGURATION="${arg#*=}"
    shift
    ;;
    -i|--install)
    BUILD_INSTALL=1
    shift
    ;;
    -n|--no-shared)
    BUILD_SHARED="OFF"
    shift
    ;;
    -p|--package)
    BUILD_PACKAGE=1
    shift
    ;;
    --rebuild)
    CMAKE_BUILD_ARGS="$CMAKE_BUILD_ARGS --clean-first "
    shift
    ;;
    -r|--release)
    BUILD_CONFIGURATION="Release"
    shift
    ;;
    "-h"|"--help")
    echo "Usage: build.sh [options]"
    echo ""
    echo "Options:"
    echo "  --clean                                     Remove build targets"
    echo "  --cleanall                                  Reset build environment"
    echo "  -c=<BUILD_CONFIG>|--config=<BUILD_CONFIG>   Specify build configuration (default = 'Debug')"
    echo "  -i|--install                                Install build targets into /usr/local"
    echo "  -n|--no-shared                              Don't build shared libraries"
    echo "  -p|--package                                Build distributable package"
    echo "  --rebuild                                   Remove build targets and rebuild"
    echo "  --release                                   Don't include debug symbols, overrides '-c|--config'"
    echo "  -u|--uninstall                              Remove build targets from /usr/local"
    echo ""
    exit 0
    shift
    ;;
    -u|--uninstall)
    BUILD_UNINSTALL=1
    shift
    ;;
    *) # unknown option
    echo "Unknown argument $arg"
    exit 1
    ;;
esac
done

if [ $BUILD_UNINSTALL -ne 0 ]; then
  echo "Uninstalling..."
  if [ -f "$BUILD_PRODUCT_DIRECTORY/install_manifest.txt" ]; then
    xargs sudo rm -f < "$BUILD_PRODUCT_DIRECTORY/install_manifest.txt"
    sudo rm -rf "$CMAKE_INSTALL_PREFIX/include/nmcs"
    echo "Done."
  fi
  exit 0
fi

if [ $BUILD_RESET -eq 1 ]; then
  if [ -d "$BUILD_PRODUCT_DIRECTORY" ]; then
    rm -rf "$BUILD_PRODUCT_DIRECTORY"
  fi
  exit 0
fi

if [ $BUILD_CLEAN -eq 1 ]; then
  if [ -d "$BUILD_PRODUCT_DIRECTORY" ]; then
    cmake --build "$BUILD_PRODUCT_DIRECTORY" --target clean -j 2> /dev/null
  fi
  exit 0
fi

echo "Looking for CMake $CMAKE_REQUIRED_VERSION..."
if [ $CMAKE_INSTALL_FOUND -eq 0 ]; then
  if [ -x "$(command -v $CMAKE_INSTALL_PATH)" ]; then
    CMAKE_CURRENT_VERSION=`$CMAKE_INSTALL_PATH --version | sort -V | tail -n 1 | awk -v n=3 '{print $n}'`
    echo "Found CMake version $CMAKE_CURRENT_VERSION."
    CompareVersions $CMAKE_CURRENT_VERSION $CMAKE_REQUIRED_VERSION
    if [ ! $? -eq 2 ]; then
      CMAKE_INSTALL_FOUND=1
    fi
  fi
fi

if [ $CMAKE_INSTALL_FOUND -eq 0 ]; then
  echo "CMake not found. Please install at least CMake version $CMAKE_REQUIRED_VERSION."
  exit 1
fi

echo "Configuring..."
cmake -B"$BUILD_PRODUCT_DIRECTORY" -G"$CMAKE_GENERATOR" -Wno-dev -Wno-deprecated -DNMCS_BUILD_SHARED="$BUILD_SHARED" -DNMCS_BUILD_ID=0 -DCMAKE_BUILD_TYPE="$BUILD_CONFIGURATION"
if [ $? -ne 0 ]; then
  echo "Failed to configure projects."
  rm -rf "$BUILD_PRODUCT_DIRECTORY"
  exit -1
fi
echo "Done."

echo "Building..."
cmake --build "$BUILD_PRODUCT_DIRECTORY" $CMAKE_BUILD_ARGS --config "$BUILD_CONFIGURATION" -j
if [ $? -ne 0 ]; then
  echo "Failed to build projects."
  exit -1
fi
echo "Done."

if [ $BUILD_PACKAGE -ne 0 ]; then
  echo "Packaging..."
  cmake --build "$BUILD_PRODUCT_DIRECTORY" --config "$BUILD_CONFIGURATION" --target package
  if [ $? -ne 0 ]; then
    echo "Failed to package targets."
    exit -1
  fi
  echo "Done."
fi

if [ $BUILD_INSTALL -ne 0 ]; then
  echo "Installing to $CMAKE_INSTALL_PREFIX..."
  sudo cmake --build "$BUILD_PRODUCT_DIRECTORY" --config "$BUILD_CONFIGURATION" --target install
  if [ $? -ne 0 ]; then
    echo "Failed to install targets."
    exit -1
  fi
  echo "Done."
fi

exit 0
