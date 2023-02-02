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

    find_package(Git)
    if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")

        # Update submodules as needed
        option(GIT_SUBMODULE "Check submodules during build" ON)
        if (GIT_SUBMODULE)
            if (NOT EXISTS ${dir_absolute}/CMakeLists.txt)
                message(STATUS "Submodule update/init")
                execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive -- ${dir_absolute}
                        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                        COMMAND_ERROR_IS_FATAL ANY)
            endif ()
        endif ()
    else()
        message("Git package not found or '${PROJECT_SOURCE_DIR}/.git' does not exist")
    endif()


    if (NOT EXISTS ${dir_absolute}/CMakeLists.txt)
        message("Could not find ${dir_absolute}/CMakeLists.txt")
        message(FATAL_ERROR "The submodules were not downloaded! GIT_SUBMODULE was turned off or failed. Please update submodules and try again.")
    endif ()

    add_subdirectory(${dir})

endfunction(add_git_submodule)
