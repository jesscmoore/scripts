# Time-stamp: <Friday 2023-04-07 19:48:27 Jess Moore>
#
# SHELL := bash
SHELL=/bin/bash

########################################################################
# HELP
#
# Help for targets defined in this Makefile.

define HELP

	install     Install scripts locally
	clean       Remove script output executables in ~/bin

endef
export HELP

help::
	@echo "$$HELP"

########################################################################

# Get the output ~/bin filenames for scripts in ~/Documents/scripts
scriptfiles := $(shell ls ../*.sh)
files_wo_paths := $(notdir ${scriptfiles})
basefiles := $(basename ${files_wo_paths})
execfiles := $(addprefix ~/bin/,${basefiles})
fullexecfiles := $(strip $(foreach f,$(execfiles),$(wildcard $(f))))

test: 
	@echo "MY VAR IS ${scriptfiles}"
	@echo "MY VAR IS ${files_wo_paths}"
	@echo "MY VAR IS ${basefiles}"
	@echo "MY_VAR IS ${execfiles}"
	@echo "MY_VARS IS ${fullexecfiles}"

clean:	
	ifneq ($(fullexecfiles),)
		rm -f $(fullexecfiles)
	endif

install: 
	for file in ../*.sh; do \
		echo $${file}; \
		chmod u+x $${file}; \
		file_wo_path=$$(basename -- "$${file}"); \
		basefile=$${file_wo_path%%.*}; \
		currdir="$(shell pwd)"; \
		ln -s $${currdir}/$${file} ~/bin/$${basefile}; \
		echo "Added $${basefile} to ~/bin"; \
	done 


