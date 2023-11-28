.DEFAULT_GOAL := all


########################################################################################
# Set this to 1 for simulation with database (signal, messages, etc.) dump,
# for example for post-siumlation DEBUG
# You can pass this via command-line
DEBUG ?= 1


########################################################################################
# Set this to 1 for live simulation with gui, for example for stopping at
# breakpoints, etc.
# You can pass this via command-line
GUI   ?= 0

ifeq ($(GUI),1)
	DEBUG := 1
endif


########################################################################################
# Always use random seed for simulation run, but override when reproducing previous run
# for example, to reproduce error
# Here we get random value from shell (bash) variable RANDOM
# try 'echo $RANDOM' in your bash shell, to try
SEED ?= $(shell bash -c 'echo $$RANDOM')


########################################################################################
# UVM Runtime arguments
UVM_TIMEOUT   ?= 5000
UVM_VERBOSITY ?= UVM_MEDIUM
UVM_TESTNAME  ?= test

UVM_OPTIONS += +UVM_VERBOSITY=$(UVM_VERBOSITY)
UVM_OPTIONS += +UVM_TIMEOUT=$(UVM_TIMEOUT)
UVM_OPTIONS += +UVM_TESTNAME=$(UVM_TESTNAME)


########################################################################################
# Setting project directory structure
MAKEFILE_FILE := $(lastword $(MAKEFILE_LIST))
MAKEFILE_HOME := $(dir $(MAKEFILE_FILE))
VERIF_DIR     :=  $(MAKEFILE_HOME)/..
SV_DIR       :=  $(VERIF_DIR)/sv
TB_DIR        :=  $(VERIF_DIR)/tb
ORIGIN_DIR    ?= $(MAKEFILE_HOME)
RESULTS_DIR   ?= $(MAKEFILE_HOME)/results


########################################################################################
# Source files
TB_SRC  += $(TB_DIR)/design.sv
TB_SRC  += $(SV_DIR)/sv_pkg.sv
TB_SRC  += $(TB_DIR)/top.sv
TOP := top


########################################################################################
# Common compilation options

# We plan to use 64-bit binaries (tools) only
COMMON_COMPILE_OPTS += -64

# We plan to use 64-bit binaries (tools) only
# All our souces to be compiled using SystemVerilog, not Verilog
COMMON_COMPILE_OPTS += -sv


########################################################################################
# UVM compile and elaboration time options
UVM_LIBRARIES += $(QUESTA_HOME)/uvm-1.2

UVM_LIB_OPTS += $(foreach LIB, $(UVM_LIBRARIES), $(addprefix -L , $(LIB)))


########################################################################################
# TB Compile-time arguments
TB_INCDIRS    += $(VERIF_DIR)/uvm


TB_COMPILE_OPTS += $(foreach INCDIR, $(TB_INCDIRS), $(addprefix +incdir+, $(INCDIR)))
TB_COMPILE_OPTS += $(foreach DEFINE, $(TB_DEFINES), $(addprefix +define+, $(DEFINE)))


########################################################################################
# Optimization-time arguments

DEBUG_OPT := -debug
ifeq ($(GUI),1)
	override DEBUG_OPT := $(DEBUG_OPT),livesim
endif
OPT_OPTS += $(DEBUG_OPT)

OPT_OPTS += -designfile design.bin
OPT_OPTS += -assertdebug


########################################################################################
# Simulation-time arguments
RUN_OPTS += -sv_seed $(SEED)
RUN_OPTS += -qwavedb=+uvm_schematic+uvm_factory+uvm_configdb
RUN_OPTS += -qwavedb=+class+transaction=uvm+classdynarray=all
RUN_OPTS += -qwavedb=+signal+memory=all
RUN_OPTS += -qwavedb=+msgmode=both+msg+displaymsgmode=both+dynarray=20+queue+glitch
RUN_OPTS += -qwavedb=+uvm_register
RUN_OPTS += -qwavedb=+assertion
RUN_OPTS += -assertdebug
RUN_OPTS += -visteestdout

ifeq ($(GUI),1)
	RUN_OPTS += -visualizer=design.bin -do "onfinish final"
else
    RUN_OPTS += -batch -do "onfinish final; run -all; quit"
endif


.PHONY: all
all: compile optimize simulate


$(RESULTS_DIR):
	@mkdir -pv $@


.PHONY: compile
compile: $(RESULTS_DIR)
	vlog                         \
		$(COMMON_COMPILE_OPTS)   \
		$(TB_COMPILE_OPTS)       \
		$(UVM_LIB_OPTS)          \
		$(USER_TB_COMPILE_OPTS)  \
		$(TB_SRC)                \
		-l $(RESULTS_DIR)/$@.log

.PHONY: optimize
optimize:
	vopt                         \
		-64                      \
		$(OPT_OPTS)              \
		$(UVM_LIB_OPTS)          \
		$(TOP)                   \
		-o top_opt               \
		-l $(RESULTS_DIR)/$@.log

.PHONY: simulate
simulate:
	vsim                         \
		$(RUN_OPTS)              \
		$(UVM_LIB_OPTS)          \
		$(UVM_OPTIONS)           \
		top_opt                  \
		-l $(RESULTS_DIR)/$(UVM_TESTNAME)_$(SEED).log \


.PHONY: lazy
lazy: RUN_OPTS += +uvm_set_action=*,NZ_DEBUG,_ALL_,UVM_NO_ACTION
lazy: simulate


.PHONY: accurate
accurate: RUN_OPTS += +uvm_set_action=*,NZ_DEBUG,UVM_INFO,UVM_NO_ACTION
accurate: simulate


.PHONY: visualizer
visualizer:
	visualizer                 \
		-designfile design.bin \
		-wavefile qwave.db     \


.PHONY: clean
clean:
	@rm -rf $(RESULTS_DIR)
	@rm -rf work/
	@rm -f design.bin
	@rm -f qwave.db
	@rm -f *.log