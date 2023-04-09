# Time-stamp: <Friday 2023-04-07 19:48:27 Jess Moore>
#
# SHELL := bash
SHELL=/bin/bash

########################################################################
# HELP
#
# Help for targets defined in this Makefile.

define HELP

	install		Install scripts locally

endef
export HELP

help::
	@echo "$$HELP"

########################################################################

execfile := $(ls ~/bin/*.sh)
# currdir = $(shell pwd)

execfiles := $(strip $(foreach f,$(execfile),$(wildcard $(f))))
		
clean:	
	ifneq ($(execfiles),)
		rm -f $(execfiles)
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


