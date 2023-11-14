# Install paths
TOOLS := /opt/si/emu/users/soummya/tools

# ARM License
export ARMLMD_LICENSE_FILE := 8224@license01
export ARM_PRODUCT_DEF := /opt/tools/arm/developmentstudio-2020.1-1/sw/ARMCompiler5.06u7/sw/mappings/gold.elmap

# FM Variables
export MAXCORE_HOME := $(TOOLS)/fm/FastModelsTools_11.23
export PVLIB_HOME := $(TOOLS)/fm/FastModelsPortfolio_11.23
export SYSTEMC_HOME := $(TOOLS)/fm/SystemC/Accellera/SystemC
#export IRIS_HOME := ${PVLIB_HOME}/Iris
#export PYTHON_PATH := ${PVLIB_HOME}/lib/python2.7:${PVLIB_HOME}/Iris/Python

#FM PATHs
export PATH := $(TOOLS)/gcc7.3.0/bin:$(PATH)
export PATH := $(MAXCORE_HOME)/bin:$(PATH)
export LD_LIBRARY_PATH := $(TOOLS)/gcc7.3.0/lib64:$(LD_LIBRARY_PATH)

ARM_COMPILER := $(shell suite_exec --help|grep '^Arm Compiler.*6')
MK_PRE := suite_exec -t "${ARM_COMPILER}"

ifeq ($(M), a78)
all: build_a78 compile_a78 run
canvas: ; sgcanvas example_a78.sgproj
else
all: build_r5 compile_r5 run
canvas: ; sgcanvas example_r5.sgproj
endif

build_r5:
	simgen -p example_r5.sgproj -b

build_a78:
	simgen -p example_a78.sgproj -b

compile_a78:
	$(MK_PRE) armclang -c --target=aarch64-arm-none-eabi -march=armv8.1-a startup_a78.S
	$(MK_PRE) armlink --ro-base=0x80000000 startup_a78.o -o image.axf --entry=start64

compile_r5:
	$(MK_PRE) armclang -c --target=arm-arm-none-eabi -march=armv8r startup_r5.S
	$(MK_PRE) armlink --ro-base=0x8000 startup_r5.o -o image.axf --entry=start
run:
	./Linux64-Release-GCC-7.3/isim_system -a image.axf
clean:
	rm -rf *.o *.axf Linux*
