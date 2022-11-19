# CudaText: file_type=Makefile; tab_size=4; tab_spaces=No;

# We are not using any builtins
MAKEFLAGS:= \
	--warn-undefined-variables \
	--no-builtin-rules \
	--no-builtin-variables \
	--output-sync=target \
	--silent

.ONESHELL:

SHELL := /bin/bash

_ = echo "[$@]"; set -euo pipefail;

clean:
	$_
	rm -vf *.o *.ppu main

default:
	$_

reformat:
	$_
	jcf 2>/dev/null -config=jcfsettings.cfg  -inplace -D .

run:
	$_
	fpc main.pas
	./main
