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

set(NMCS_PLATFORM_INCLUDES
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/platformalloc.h
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/platformguid.h
#   ${NMCS_INCLUDE_DIRECTORY}/nmcs/platformvault.h
  platformcommon.h
)

set(NMCS_PLATFORM_SOURCES
  ${NMCS_TARGET_SYSTEM}/platformalloc.cpp
  ${NMCS_TARGET_SYSTEM}/platformguid.cpp
#   ${NMCS_TARGET_SYSTEM}/platformvault.cpp
)

if(NMCS_TARGET_SYSTEM STREQUAL "darwin")
  set(NMCS_PRIVATE_PLATFORM_DEPENDENCIES
    "-framework Carbon"
    "-framework IOKit"
    "-framework Security"
  )
endif()

add_library(nmcsplatform
  ${NMCS_PLATFORM_INCLUDES}
  ${NMCS_PLATFORM_SOURCES}
)

target_link_libraries(nmcsplatform PRIVATE
  ${NMCS_PRIVATE_PLATFORM_DEPENDENCIES}
)

if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
  set_target_properties(nmcsplatform PROPERTIES VERSION ${PROJECT_VERSION})
  set_target_properties(nmcsplatform PROPERTIES SOVERSION ${PROJECT_VERSION})
endif()

set_target_properties(nmcsplatform PROPERTIES OUTPUT_NAME "nmcsplatform")
