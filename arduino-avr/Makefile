.PHONY: ref
ref:
	@mkdir -p ref
	@- rm -rf ref/*
	@cp -r /usr/share/arduino/hardware/arduino/cores/* ref/
	@mkdir -p ref/avr
	@cp -r /usr/share/arduino/hardware/tools/avr/lib/avr/include/* ref/avr
	@cp -r /usr/share/arduino/hardware/arduino/variants/standard ref/
	@cp    /usr/share/arduino/hardware/arduino/variants/eightanaloginputs/pins_arduino.h ref/arduino
#------------------------------------------------------------------------------#
.DEFAULT_GOAL:= help

.PHONY: help
help:
	@echo "Each project has its own self contained directory. This project uses the arduino-mk package."
	@echo
	@echo usage for this makefile:
	@echo "    make ref            - copy arduino headers into the reference folder."
