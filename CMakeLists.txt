cmake_minimum_required(VERSION 2.6.0) 
#cmake_minimum_required(VERSION 2.8.8)  # need the object library

# set up pods
set(POD_NAME spotless)
include(cmake/pods.cmake)

# setup matlab pods-compliance
include(cmake/matlab_pods.cmake)
pods_configure_matlab_paths()

message(STATUS "Writing addpath_spotless.m and rmpath_spotless.m to ${CMAKE_INSTALL_PREFIX}/matlab") 
file(WRITE ${CMAKE_INSTALL_PREFIX}/matlab/addpath_spotless.m
	   "function addpath_spotless()\n"
	   "  wd = cd(fullfile('${CMAKE_CURRENT_SOURCE_DIR}','spotless'));\n"
	   "  spot_install();\n"
	   "  cd(wd);\n"
    )

file(WRITE ${CMAKE_INSTALL_PREFIX}/matlab/rmpath_spotless.m
	   "function rmpath_spotless()\n"
	   "  spotdir=fullfile('${CMAKE_CURRENT_SOURCE_DIR}','spotless');\n"
	   "  rmpath(spotdir);\n"
	   "  rmpath(fullfile(spotdir,'bin'));\n"
	   "  rmpath(fullfile(spotdir,'util'));\n"
	   "  rmpath(fullfile(spotdir,'mint'));\n"
	   "  rmpath(fullfile(spotdir,'mss'));\n"
    )


