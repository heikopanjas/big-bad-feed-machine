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

include(FetchContent)

# Silence warnings when compiling external dependencies
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations -Wno-constant-logical-operand")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-deprecated-declarations -Wno-constant-logical-operand")

set(FETCHCONTENT_QUIET   ON)
set(FETCHCONTENT_VERBOSE OFF)

FetchContent_Declare(libcli11
  GIT_REPOSITORY ${LIBCLI11_URL}
  GIT_SHALLOW    ON
  GIT_PROGRESS   OFF
  GIT_TAG        ${LIBCLI11_VERSION}
  EXCLUDE_FROM_ALL
)
set(CLI11_SINGLE_FILE    OFF CACHE INTERNAL "")
set(CLI11_BUILD_DOCS     OFF CACHE INTERNAL "")
set(CLI11_BUILD_TESTS    OFF CACHE INTERNAL "")
set(CLI11_BUILD_EXAMPLES OFF CACHE INTERNAL "")
FetchContent_MakeAvailable(libcli11)

# zlib has to be available before curl, which locates it through find_package(ZLIB).
FetchContent_Declare(zlib
  GIT_REPOSITORY ${LIBZ_URL}
  GIT_SHALLOW    ON
  GIT_PROGRESS   OFF
  GIT_TAG        ${LIBZ_VERSION}
  EXCLUDE_FROM_ALL
  OVERRIDE_FIND_PACKAGE
)
set(SKIP_INSTALL_ALL    ON  CACHE INTERNAL "")
set(ZLIB_BUILD_EXAMPLES OFF CACHE INTERNAL "")
FetchContent_MakeAvailable(zlib)

# zlib 1.3.1 ships neither a ZLIB::ZLIB alias nor a package config, so supply both through
# the FetchContent redirect. This is what makes curl link our static zlib instead of the
# system one. zlibstatic already exports the source and binary directories as PUBLIC include
# directories, so zlib.h and the generated zconf.h propagate to consumers.
file(WRITE "${CMAKE_FIND_PACKAGE_REDIRECTS_DIR}/zlib-extra.cmake"
"if(NOT TARGET ZLIB::ZLIB)
  add_library(ZLIB::ZLIB ALIAS zlibstatic)
endif()
set(ZLIB_LIBRARIES ZLIB::ZLIB)
set(ZLIB_INCLUDE_DIRS \"${zlib_SOURCE_DIR};${zlib_BINARY_DIR}\")
")

FetchContent_Declare(libcurl
  GIT_REPOSITORY ${LIBCURL_URL}
  GIT_SHALLOW    ON
  GIT_PROGRESS   OFF
  GIT_TAG        ${LIBCURL_VERSION}
  EXCLUDE_FROM_ALL
)
set(BUILD_CURL_EXE      OFF  CACHE INTERNAL "")
set(BUILD_BINDINGS      OFF  CACHE INTERNAL "")
set(BUILD_TESTING       OFF  CACHE INTERNAL "")
set(ENABLE_MANUAL       OFF  CACHE INTERNAL "")
set(HTTP_ONLY           ON   CACHE INTERNAL "")
set(CURL_USE_OPENSSL    ON   CACHE INTERNAL "")
set(CURL_CA_PATH        auto CACHE INTERNAL "")
# ON rather than AUTO: find_package(ZLIB REQUIRED) fails loudly if the redirect above ever
# stops working, instead of silently falling back to the system zlib.
set(CURL_ZLIB           ON   CACHE INTERNAL "")
# Keep whatever happens to be installed on the build host out of the build.
set(CURL_USE_LIBSSH2    OFF  CACHE INTERNAL "")
set(CURL_USE_LIBPSL     OFF  CACHE INTERNAL "")
set(USE_LIBIDN2         OFF  CACHE INTERNAL "")
# EXCLUDE_FROM_ALL only makes install rules be ignored at install time. curl's
# install(EXPORT CURLTargets) and export(TARGETS ...) are still generated, and neither can
# export libcurl_static now that it links zlibstatic, which is in no export set.
set(CURL_DISABLE_INSTALL      ON  CACHE INTERNAL "")
set(CURL_ENABLE_EXPORT_TARGET OFF CACHE INTERNAL "")
FetchContent_MakeAvailable(libcurl)

FetchContent_Declare(libxml2
  GIT_REPOSITORY ${LIBXML2_URL}
  GIT_SHALLOW    ON
  GIT_PROGRESS   OFF
  GIT_TAG        ${LIBXML2_VERSION}
  EXCLUDE_FROM_ALL
)
set(LIBXML2_WITH_ICONV    OFF CACHE INTERNAL "")
set(LIBXML2_WITH_ICU      OFF CACHE INTERNAL "")
set(LIBXML2_WITH_LEGACY   OFF CACHE INTERNAL "")
set(LIBXML2_WITH_LZMA     OFF CACHE INTERNAL "")
set(LIBXML2_WITH_PROGRAMS OFF CACHE INTERNAL "")
set(LIBXML2_WITH_PYTHON   OFF CACHE INTERNAL "")
set(LIBXML2_WITH_TESTS    OFF CACHE INTERNAL "")
set(LIBXML2_WITH_DEBUG    OFF CACHE INTERNAL "")
set(LIBXML2_WITH_ZLIB     OFF CACHE INTERNAL "")
FetchContent_MakeAvailable(libxml2)

FetchContent_Declare(libsimdutf
  GIT_REPOSITORY ${LIBSIMDUTF_URL}
  GIT_SHALLOW    ON
  GIT_PROGRESS   OFF
  GIT_TAG        ${LIBSIMDUTF_VERSION}
  EXCLUDE_FROM_ALL
)
set(SIMDUTF_BENCHMARKS OFF CACHE INTERNAL "")
set(BUILD_TESTING      OFF CACHE INTERNAL "")
FetchContent_MakeAvailable(libsimdutf)

FetchContent_Declare(libsimdjson
  GIT_REPOSITORY ${LIBSIMDJSON_URL}
  GIT_SHALLOW    ON
  GIT_PROGRESS   OFF
  GIT_TAG        ${LIBSIMDJSON_VERSION}
  EXCLUDE_FROM_ALL
)
set(SIMDJSON_DEVELOPER_MODE         OFF CACHE INTERNAL "")
set(SIMDJSON_DISABLE_DEPRECATED_API OFF CACHE INTERNAL "")
set(SIMDJSON_ALLOW_DOWNLOADS        OFF CACHE INTERNAL "")
set(SIMDJSON_ENABLE_FUZZING         OFF CACHE INTERNAL "")
FetchContent_MakeAvailable(libsimdjson)

FetchContent_Declare(libspdlog
  GIT_REPOSITORY ${LIBSPDLOG_URL}
  GIT_SHALLOW    ON
  GIT_PROGRESS   OFF
  GIT_TAG        ${LIBSPDLOG_VERSION}
  EXCLUDE_FROM_ALL
)
set(SPDLOG_BUILD_EXAMPLE OFF CACHE INTERNAL "")
FetchContent_MakeAvailable(libspdlog)

FetchContent_Declare(libwhisper
  GIT_REPOSITORY ${LIBWHISPER_URL}
  GIT_SHALLOW    ON
  GIT_PROGRESS   OFF
  GIT_TAG        ${LIBWHISPER_VERSION}
  EXCLUDE_FROM_ALL
)
set(WHISPER_ALL_WARNINGS           OFF CACHE INTERNAL "")
set(WHISPER_ALL_WARNINGS_3RD_PARTY OFF CACHE INTERNAL "")
set(WHISPER_BUILD_TESTS            OFF CACHE INTERNAL "")
set(WHISPER_BUILD_EXAMPLES         OFF CACHE INTERNAL "")
set(WHISPER_PERF                   OFF CACHE INTERNAL "")
FetchContent_MakeAvailable(libwhisper)

find_path(LIBUUID_INCLUDE_DIR uuid.h PATH_SUFFIXES uuid)
find_library(LIBUUID_LIBRARY libuuid.a)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
