cmake_minimum_required(VERSION 3.19)

function(initialize_git_submodules)
    # update a Git submodule from cmake
    #
    # Usage: in CMakeLists.txt
    #
    # include(InitializeGitSubmodules.cmake)
    # initialize_git_submodules([specific submodule path])

    if (DEFINED ARGV0)
        set(dir ARGV0)
    else()
        set(dir ${CMAKE_CURRENT_SOURCE_DIR})
    endif ()

    cmake_path(ABSOLUTE_PATH dir BASE_DIRECTORY "${PROJECT_SOURCE_DIR}" OUTPUT_VARIABLE dir_absolute)
    message("dir: ${dir}")
    message("dir_absolute: ${dir_absolute}")

    # Update submodules as needed
    option(GIT_SUBMODULE "Check submodules during build" ON)
    if (NOT GIT_SUBMODULE)
        message("Checking submodules during build is disabled.")
        return()
    endif ()

    # maybe this check is not necessary
    if (NOT EXISTS "${PROJECT_SOURCE_DIR}/.git")
        message("No git repository in ${PROJECT_SOURCE_DIR}")
    endif ()

    find_package(Git)
    if (NOT GIT_FOUND)
        message("Git package not found.")
        return()
    endif ()

    message(STATUS "Git recursive submodule update/init in ${dir_absolute}")
    execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive -- ${dir_absolute}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            COMMAND_ERROR_IS_FATAL ANY)

endfunction(initialize_git_submodules)
