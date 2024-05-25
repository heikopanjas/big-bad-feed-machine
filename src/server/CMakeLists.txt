# ##############################################################################
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
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# ##############################################################################

include_directories(
  ${LIBCURL_INCLUDE_PATH}
  ${LIBXML2_INCLUDE_PATH}
  ${LIBSIMDJSON_INCLUDE_PATH}
  ${LIBSPDLOG_INCLUDE_PATH}
)

set(NMCS_SERVER_INCLUDES
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/servercredentialservice.h
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/serverfileservice.h
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/serverhttpservice.h
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/serverservice.h
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/serverservicecallback.h
  ${NMCS_INCLUDE_DIRECTORY}/nmcs/serverservicemanager.h
  serverattachedpictureframe.h
  serverchapterframe.h
  servercommentsframe.h
  serverconfiguration.h
  serverframe.h
  serverframecontroller.h
  serverframefactory.h
  serverframeresource.h
  serverid3v2.h
  serverservicefactory.h
  servertableofcontentsframe.h
  servertextinformationframe.h
  serverurllinkframe.h
)

set(NMCS_SERVER_SOURCES
  server.cpp
  serverattachedpictureframe.cpp
  serverchapterframe.cpp
  servercommentsframe.cpp
  serverconfiguration.cpp
  servercredentialservice.cpp
  serverfileservice.cpp
  serverframe.cpp
  serverframecontroller.cpp
  serverframefactory.cpp
  serverhttpservice.cpp
  serverid3v2.cpp
  serverservicefactory.cpp
  serverservicemanager.cpp
  servertableofcontentsframe.cpp
  servertextinformationframe.cpp
  serverurllinkframe.cpp
)

set(NMCS_PUBLIC_SERVER_DEPENDENCIES
  nmcsmodel
)

set(NMCS_PRIVATE_SERVER_DEPENDENCIES
  ${LIBCURL_LIBRARY}
  ${LIBXML2_LIBRARY}
  ${LIBSIMDJSON_LIBRARY}
  ${LIBSPDLOG_LIBRARY}
)

add_library(nmcsserver ${NMCS_SERVER_INCLUDES} ${NMCS_SERVER_SOURCES})

# add_dependencies(nmcsserver
#   ${NMCS_PUBLIC_SERVER_DEPENDENCIES}
#   ${NMCS_PRIVATE_SERVER_DEPENDENCIES}
# )

target_link_libraries(nmcsserver PUBLIC
  ${NMCS_PUBLIC_SERVER_DEPENDENCIES}
)

target_link_libraries(nmcsserver PRIVATE
  ${LIBCURL_LIBRARY_PATH}
  ${LIBXML2_LIBRARY_PATH}
  ${LIBSIMDJSON_LIBRARY_PATH}
  ${LIBSPDLOG_LIBRARY_PATH}
)

if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
  set_target_properties(nmcsserver PROPERTIES VERSION ${PROJECT_VERSION})
  set_target_properties(nmcsserver PROPERTIES SOVERSION ${PROJECT_VERSION})
endif()

set_target_properties(nmcsserver PROPERTIES OUTPUT_NAME "nmcsserver")
