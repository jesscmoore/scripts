# Time-stamp: <Friday 2023-04-07 19:48:27 Jess Moore>
#
# SHELL := bash
SHELL=/bin/bash

########################################################################
# HELP
#
# Help for targets defined in this Makefile.

define HELP

	install		Developer install scripts locally

endef
export HELP

help::
	@echo "$$HELP"

########################################################################

install: 
	echo "foo"
	cd ..; for file in *.sh; do \
		echo $${file}; \
		ls -lt $${file}; \
		chmod u+x $${file}; \
		ls -lt $${file}; \
		basefile=$${file%%.*}; \
		echo $${basefile}; \
		[ -f ~/bin/$${basefile} ] && rm ~/bin/$${basefile}; \
		ln -s $${file} ~/bin/$${basefile}; \
		echo "Added $${basefile} to ~/bin"; \
	done 


