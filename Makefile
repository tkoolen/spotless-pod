# Default pod makefile distributed with pods version: 12.11.14

# Figure out where to build the software.
#   Use BUILD_PREFIX if it was passed in.
#   If not, search up to four parent directories for a 'build' directory.
#   Otherwise, use ./build.
ifeq "$(BUILD_PREFIX)" ""
BUILD_PREFIX:=$(shell for pfx in ./ .. ../.. ../../.. ../../../..; do d=`pwd`/$$pfx/build;\
               if [ -d "$$d" ]; then echo $$d; exit 0; fi; done; echo `pwd`/build)
endif
# create the build directory if needed, and normalize its path name
BUILD_PREFIX:=$(shell mkdir -p "$(BUILD_PREFIX)" && cd "$(BUILD_PREFIX)" && echo `pwd`)

# Default to a release build.  If you want to enable debugging flags, run
# "make BUILD_TYPE=Debug"
ifeq "$(BUILD_TYPE)" ""
BUILD_TYPE="Release"
endif

# note: this is evaluated at run time, so must be in the pod-build directory
CMAKE_MAKE_PROGRAM="`cmake -LA -N | grep CMAKE_MAKE_PROGRAM | cut -d "=" -f2`"

all: pod-build/Makefile
	cd pod-build && $(CMAKE_MAKE_PROGRAM) all install 

pod-build/Makefile:
	$(MAKE) configure

.PHONY: configure
configure:
	@echo "\nBUILD_PREFIX: $(BUILD_PREFIX)\n\n"

	# create the temporary build directory if needed
	@mkdir -p pod-build

	# run CMake to generate and configure the build scripts
	@cd pod-build && cmake -DCMAKE_INSTALL_PREFIX="$(BUILD_PREFIX)" \
		   -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) ..

release_filelist:
	find * -type f | grep -v "pod-build" | grep -v "\.git" 

clean:
	-if [ -d pod-build ]; then $(MAKE) -C pod-build clean; rm -rf pod-build; fi

# other (custom) targets are passed through to the cmake-generated Makefile 
%::
	cd pod-build && $(CMAKE_MAKE_PROGRAM) $@

# Default to a less-verbose build.  If you want all the gory compiler output,
# run "make VERBOSE=1"
$(VERBOSE).SILENT:

