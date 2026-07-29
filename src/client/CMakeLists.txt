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

set(NMCS_CLIENT_INCLUDES
  clientchapterscommand.h
  clientcommon.h
  clientguidgencommand.h
  clienthexdump.h
)

set(NMCS_CLIENT_SOURCES
  client.cpp
  clientapplication.cpp
  clientchapterscommand.cpp
  clientguidgencommand.cpp
  clienthexdump.cpp
)

set(NMCS_PUBLIC_CLIENT_DEPENDENCIES
  nmcsserver
)

set(NMCS_PRIVATE_CLIENT_DEPENDENCIES
  CLI11::CLI11
)

add_executable(nmcsclient
  ${NMCS_CLIENT_INCLUDES}
  ${NMCS_CLIENT_SOURCES}
)

target_link_libraries(nmcsclient PUBLIC
  ${NMCS_PUBLIC_CLIENT_DEPENDENCIES}
)

target_link_libraries(nmcsclient PRIVATE
  ${NMCS_PRIVATE_CLIENT_DEPENDENCIES}
)

if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
  set_target_properties(nmcsclient PROPERTIES VERSION ${PROJECT_VERSION})
  set_target_properties(nmcsclient PROPERTIES SOVERSION ${PROJECT_VERSION})
endif()

set_target_properties(nmcsclient PROPERTIES OUTPUT_NAME "nmcscli")
