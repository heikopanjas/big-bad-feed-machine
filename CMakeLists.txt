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

cmake_minimum_required(VERSION 3.28)

project(nmcs
  VERSION 2.0.0
  DESCRIPTION "Network Media Control System"
  LANGUAGES C CXX
)

message(STATUS "NMCS_BUILD_ID = ${NMCS_BUILD_ID}")

set(NMCS_VERSION "${PROJECT_VERSION}")
if((NOT DEFINED NMCS_BUILD_ID) OR (NMCS_BUILD_ID STREQUAL "0") OR (NMCS_BUILD_ID EQUAL 0))
  set(NMCS_BUILD_ID 0)
  set(NMCS_BUILD_TIMESTAMP "private")
else()
  string(TIMESTAMP NMCS_BUILD_TIMESTAMP "%Y-%m-%d %H:%M:%S")
endif()
configure_file(version.h.in version.h)
include_directories(${CMAKE_BINARY_DIR})

if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  set(CMAKE_C_STANDARD                     23)
  set(CMAKE_CXX_STANDARD                   23)
  set(CMAKE_CXX_STANDARD_REQUIRED          ON)
  set(CMAKE_CXX_EXTENSIONS                 OFF)
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)
endif()

if(WIN32)
    set(NMCS_TARGET_SYSTEM "windows")
elseif(APPLE)
    set(NMCS_TARGET_SYSTEM "darwin")
elseif(UNIX)
  execute_process(COMMAND uname -a RESULT_VARIABLE UNAME_RESULT OUTPUT_VARIABLE UNAME_OUTPUT OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(UNAME_RESULT EQUAL 0)
    if(${UNAME_OUTPUT} MATCHES "[L|l]inux")
        set(NMCS_TARGET_SYSTEM "linux")
    else()
      message(STATUS "Unsupported platform: " ${UNAME_OUTPUT})
      message(FATAL_ERROR "Supported platforms are Windows, Darwin and Linux")
    endif()
  else()
    message(FATAL_ERROR "Failed to run uname, result: ${UNAME_RESULT}")
  endif()
else()
  message(FATAL_ERROR "Supported platforms are Windows, Darwin and Linux")
endif()

option(NMCS_BUILD_SHARED "Build the nmcs libraries as shared libraries" ON)

set(LIBCLI11_URL        "https://github.com/CLIUtils/CLI11.git")
set(LIBCLI11_VERSION    "v2.4.1")
set(LIBZ_URL            "https://github.com/madler/zlib.git")
set(LIBZ_VERSION        "v1.3.1")
set(LIBCURL_URL         "https://github.com/curl/curl.git")
set(LIBCURL_VERSION     "curl-8_6_0")
set(LIBXML2_URL         "https://github.com/GNOME/libxml2.git")
set(LIBXML2_VERSION     "v2.12.6")
set(LIBSIMDUTF_URL      "https://github.com/simdutf/simdutf.git")
set(LIBSIMDUTF_VERSION  "v5.0.0")
set(LIBSIMDJSON_URL     "https://github.com/simdjson/simdjson.git")
set(LIBSIMDJSON_VERSION "v3.8.0")
set(LIBSPDLOG_URL       "https://github.com/gabime/spdlog.git")
set(LIBSPDLOG_VERSION   "v1.13.0")
set(LIBWHISPER_URL      "https://github.com/ggerganov/whisper.cpp.git")
set(LIBWHISPER_VERSION  "v1.5.4")

set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE INTERNAL "")

# The dependencies are always built as static libraries. CMP0077 has to be forced to NEW:
# several dependencies reset it to OLD through their own cmake_minimum_required, and their
# option(BUILD_SHARED_LIBS ...) calls would then delete the normal variable set below and
# write a cache entry of their own.
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)
set(BUILD_SHARED_LIBS OFF)

set(CMAKE_C_FLAGS_SAVE ${CMAKE_C_FLAGS})
set(CMAKE_CXX_FLAGS_SAVE ${CMAKE_CXX_FLAGS})
include(cmake/${NMCS_TARGET_SYSTEM}.cmake)
set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS_SAVE})
set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS_SAVE})

# From here on BUILD_SHARED_LIBS applies to the nmcs libraries only.
set(BUILD_SHARED_LIBS ${NMCS_BUILD_SHARED})
if(NMCS_BUILD_SHARED)
  add_compile_definitions("NMCS_SHARED=1")
endif()

set(NMCS_INCLUDE_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/include")
include_directories(${NMCS_INCLUDE_DIRECTORY})

add_subdirectory("src/platform")
add_subdirectory("src/runtime")
add_subdirectory("src/model")
add_subdirectory("src/server")
add_subdirectory("src/agent")
add_subdirectory("src/client")

option(ENABLE_VAULT_SERVICE ON)
if(ENABLE_VAULT_SERVICE)
    add_subdirectory("src/services/vault")
endif()

option(ENABLE_HTTP_CLIENT_SERVICE ON)
if(ENABLE_HTTP_CLIENT_SERVICE)
    add_subdirectory("src/services/httpclient")
endif()

option(ENABLE_AUPHONIC_SERVICE ON)
if(ENABLE_AUPHONIC_SERVICE)
    add_subdirectory("src/services/auphonic")
endif()

option(ENABLE_PODLOVE_SERVICE ON)
if(ENABLE_PODLOVE_SERVICE)
    add_subdirectory("src/services/podlove")
endif()

option(ENABLE_TRANSCRIPTION_SERVICE ON)
if(ENABLE_TRANSCRIPTION_SERVICE)
    add_subdirectory("src/services/transcription")
endif()

option(ENABLE_NATIVE_GATEWAY ON)
if(ENABLE_NATIVE_GATEWAY)
    add_subdirectory("src/gateways/northbound/native")
endif()

option(ENABLE_RPC_GATEWAY ON)
if(ENABLE_RPC_GATEWAY)
    add_subdirectory("src/gateways/northbound/rpc")
endif()

option(ENABLE_SQLITE_GATEWAY ON)
if(ENABLE_SQLITE_GATEWAY)
    add_subdirectory("src/gateways/southbound/sqlite")
endif()

option(ENABLE_RSS_GATEWAY ON)
if(ENABLE_RSS_GATEWAY)
    add_subdirectory("src/gateways/southbound/rss")
endif()

install(TARGETS nmcsplatform nmcsruntime nmcsmodel nmcsserver nmcsagent nmcsclient
  RUNTIME DESTINATION "bin"
  LIBRARY DESTINATION "lib"
  ARCHIVE DESTINATION "lib/${PROJECT_NAME}"
)
install(DIRECTORY "include/" DESTINATION include)

set(CPACK_PACKAGE_NAME "nmcs")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${NMCS_VERSION}-build${NMCS_BUILD_ID}-${NMCS_TARGET_SYSTEM}")
set(CPACK_PACKAGE_VENDOR "ultralove")
set(CPACK_PACKAGE_CONTACT "staff@ultralove.io")
set(CPACK_PACKAGE_URL "https://github.com/ultralove/ultralove-nmcs")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "network media control system")
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_GENERATOR "ZIP;TGZ")
set(CPACK_THREADS 0)
include(CPack)
