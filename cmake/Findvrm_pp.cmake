# Copyright (c) 2015-2016 Vittorio Romeo
# License: Academic Free License ("AFL") v. 3.0
# AFL License page: http://opensource.org/licenses/AFL-3.0
# http://vittorioromeo.info | vittorio.romeo@outlook.com

# Adapted from Louise Dionne's FindHana.cmake file

# Copyright Louis Dionne 2015
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.md or copy at http://boost.org/LICENSE_1_0.txt)

find_path(
    VRM_PP_INCLUDE_DIR

    NAMES vrm/pp.hpp
    DOC "Include directory for the vrm_pp library"

    PATH_SUFFIXES include/

    PATHS
        "${PROJECT_SOURCE_DIR}/../vrm_pp/"
        ${VRM_PP_ROOT}
        $ENV{VRM_PP_ROOT}
        /usr/local/
        /usr/
        /sw/
        /opt/local/
        /opt/csw/
        /opt/
        "${PROJECT_SOURCE_DIR}/extlibs/vrm_pp/"
        "${CMAKE_CURRENT_LIST_DIR}/../../"
        "${CMAKE_CURRENT_LIST_DIR}/../"

        NO_DEFAULT_PATH
)

if (NOT EXISTS "${VRM_PP_INCLUDE_DIR}" AND DEFINED VRM_PP_CLONE_DIR)
    set(_build_dir "${CMAKE_CURRENT_BINARY_DIR}/vrm_pp")

    if (DEFINED VRM_PP_ENABLE_TESTS)
        set(_test_cmd ${CMAKE_COMMAND} --build ${_build_dir} --target check)
    else()
        set(_test_cmd "")
    endif()

    include(ExternalProject)
    ExternalProject_Add(vrm_pp
        PREFIX ${_build_dir}
        STAMP_DIR ${_build_dir}/_stamps
        TMP_DIR ${_build_dir}/_tmp

        # Since we don't have any files to download, we set the DOWNLOAD_DIR
        # to TMP_DIR to avoid creating a useless empty directory.
        DOWNLOAD_DIR ${_build_dir}/_tmp

        # Download step
        GIT_REPOSITORY https://github.com/SuperV1234/vrm_pp
        GIT_TAG master
        TIMEOUT 20

        # Configure step
        SOURCE_DIR "${VRM_PP_CLONE_DIR}"
        CMAKE_ARGS -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}

        BINARY_DIR "${_build_dir}"
        BUILD_COMMAND ""

        # Install step (nothing to be done)
        INSTALL_COMMAND ""

        # Test step
        TEST_COMMAND ${_test_cmd}
    )

    set(VRM_PP_INCLUDE_DIR "${VRM_PP_CLONE_DIR}/include")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VRM_PP DEFAULT_MSG VRM_PP_INCLUDE_DIR)
