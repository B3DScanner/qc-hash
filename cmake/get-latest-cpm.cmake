if(NOT EXISTS "${CMAKE_BINARY_DIR}/cmake/CPM.cmake")
    file(DOWNLOAD
        https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/CPM.cmake
        "${CMAKE_BINARY_DIR}/cmake/CPM.cmake"
    )
endif()

include("${CMAKE_BINARY_DIR}/cmake/CPM.cmake")