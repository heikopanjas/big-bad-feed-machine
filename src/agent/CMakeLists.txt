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

set(NMCS_AGENT_INCLUDES
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/platform.h
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/runtime.h
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/model.h
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/server.h
)

set(NMCS_AGENT_SOURCES
  agent.cpp
)

set(NMCS_PUBLIC_AGENT_DEPENDENCIES
  nmcsplatform
  nmcsruntime
  nmcsmodel
  nmcsserver
)

add_executable(nmcsagent
  ${NMCS_AGENT_INCLUDES}
  ${NMCS_AGENT_SOURCES}
)

# add_dependencies(nmcsagent
#   ${NMCS_PUBLIC_AGENT_DEPENDENCIES}
# )

target_link_libraries(nmcsagent PUBLIC
  ${NMCS_PUBLIC_AGENT_DEPENDENCIES}
)

if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
  set_target_properties(nmcsagent PROPERTIES VERSION ${PROJECT_VERSION})
  set_target_properties(nmcsagent PROPERTIES SOVERSION ${PROJECT_VERSION})
endif()

set_target_properties(nmcsagent PROPERTIES OUTPUT_NAME "nmcsagent")
