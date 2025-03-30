cmake_minimum_required(VERSION 3.30)

set(VERSION_PREFIX "qc" CACHE STRING "Prefix for generated files and definitions")

# Install semantic version from github plugin
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/get-latest-cpm.cmake)
CPMAddPackage("gh:B3DScanner/Version.cmake#master")

project(qc-hash VERSION ${VERSION_SEMANTIC} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_DEBUG_POSTFIX d)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(BUILD_SHARED_LIBS OFF)

if(MSVC)
    add_compile_options(/std:c++20)
endif()

add_library(${PROJECT_NAME} STATIC ${CMAKE_CURRENT_SOURCE_DIR}/srcs/main.cpp)
target_link_libraries(${PROJECT_NAME} version::version)

file(GLOB HEADER_FILES "include/*.hpp")
install(FILES ${HEADER_FILES} DESTINATION include)
install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
install(TARGETS ${PROJECT_NAME} LIBRARY DESTINATION lib)

install(TARGETS ${PROJECT_NAME} cmakeVersion
    EXPORT ${PROJECT_NAME}Targets
    FILE_SET HEADERS
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include)
	
install(EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION lib/cmake/${PROJECT_NAME})	
	
set(GENERATED_CONFIG_FILE_DIR "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake")
	
configure_file(
"${CMAKE_CURRENT_SOURCE_DIR}/cmake/config.cmake.in"
"${GENERATED_CONFIG_FILE_DIR}"
@ONLY
)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${PROJECT_NAME}ConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion)

install(FILES "${GENERATED_CONFIG_FILE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION lib/cmake/${PROJECT_NAME})		