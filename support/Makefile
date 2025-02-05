# Time-stamp: <Friday 2023-04-07 19:48:27 Jess Moore>
#
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

# Get the output ~/bin filenames for scripts in scripts repo
# Uses make syntax
scriptfiles := $(shell ls ../*.sh)
# Removes dir and file suffix
basefiles := $(basename $(notdir ${scriptfiles}))
# Adds output dir ~/bin prefix
execfiles := $(addprefix ~/bin/,${basefiles})
fullexecfiles := $(strip $(foreach f,$(execfiles),$(wildcard $(f))))

test:
	@echo "MY FILES ARE ${scriptfiles}"
	@echo "MY FILES ARE ${basefiles}"
	@echo "MY FILES ARE ${execfiles}"
	@echo "MY FILES ARE ${fullexecfiles}"

# Remove output ~/bin filenames if exist, if not provide sensible msg
# This only removes the softlinks to scripts in scripts repo
clean:
ifneq (${fullexecfiles},)
	rm -f $(fullexecfiles)
endif

# Install scripts from scripts repo in ~/bin
# $$ req when calling var from within for loop line
install:
	for file in ../*.sh; do \
		echo $${file}; \
		chmod u+x $${file}; \
		file_wo_path=$$(basename -- "$${file}"); \
		basefile=$${file_wo_path%%.*}; \
		currdir="$(shell pwd)"; \
		ln -sf $${currdir}/$${file} ~/bin/$${basefile}; \
		echo "Added $${basefile} to ~/bin"; \
	done
