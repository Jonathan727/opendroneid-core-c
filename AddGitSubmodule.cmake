cmake_minimum_required(VERSION 3.19)

function(add_git_submodule dir)
    # add a Git submodule directory to CMake, assuming the
    # Git submodule directory is a CMake project.
    #
    # Usage: in CMakeLists.txt
    #
    # include(AddGitSubmodule.cmake)
    # add_git_submodule(mysubmod_dir)

    cmake_path(ABSOLUTE_PATH dir BASE_DIRECTORY "${PROJECT_SOURCE_DIR}" OUTPUT_VARIABLE dir_absolute)
    message("dir: ${dir}")
    message("dir_absolute: ${dir_absolute}")

    # Update submodules as needed
    option(GIT_SUBMODULE "Check submodules during build" ON)
    if (NOT GIT_SUBMODULE)
        message("Checking submodules during build is disabled.")
        add_subdirectory(${dir})
        return()
    endif ()

    # maybe this check is not necessary
    if (NOT EXISTS "${PROJECT_SOURCE_DIR}/.git")
        message("No git repository in ${PROJECT_SOURCE_DIR}")
    endif ()

    find_package(Git)
    if (NOT GIT_FOUND)
        message("Git package not found.")
        add_subdirectory(${dir})
        return()
    endif ()

    if (EXISTS ${dir_absolute}/CMakeLists.txt)
        message("Git submodule ${dir} found and already checked out.")
        add_subdirectory(${dir})
        return()
    endif ()

    message(STATUS "Git submodule ${dir} update/init")
    execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive -- ${dir_absolute}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            COMMAND_ERROR_IS_FATAL ANY)

    if (NOT EXISTS ${dir_absolute}/CMakeLists.txt)
        message(WARNING "Could not find ${dir_absolute}/CMakeLists.txt even after running '${GIT_EXECUTABLE} submodule update --init --recursive -- ${dir_absolute}'")
    endif ()

    add_subdirectory(${dir})

endfunction(add_git_submodule)
