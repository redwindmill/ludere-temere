PATH_SCRIPT := ./mysterium.py
PATH_SETS := ./data/sets.json

MODE := original
PLAYERS := 3
DIFFICULTY := normal

SETS := \
	base \
	hidden-signs \
	secrets-and-lies \
	promo-2015 \
	promo-2017

#------------------------------------------------------------------------------#

.PHONY: setup
setup:
	@$(PATH_SCRIPT) $(PATH_SETS) \
		-p $(PLAYERS) \
		-d $(DIFFICULTY) \
		-m $(MODE) \
		-s $(SETS)

.PHONY: list
list:
	@$(PATH_SCRIPT) $(PATH_SETS) -l \
		-p $(PLAYERS) \
		-d $(DIFFICULTY) \
		-m $(MODE) \
		-s $(SETS)
	@echo

#------------------------------------------------------------------------------#
.DEFAULT_GOAL:= help

.PHONY: help
help:
	@echo usage:
	@echo "    make [OPTION] [DIFFICULTY=<...>] [PLAYERS=<...>] [SETS=\"...\"]"
	@echo "        DIFFICULTY : <easy/normal/hard/insane/nightmare>"
	@echo "        PLAYERS    : <2/3/4/5/6/7>"
	@echo "        defaults   : DIFFICULTY=$(DIFFICULTY)"
	@echo "                     PLAYERS=$(PLAYERS)"
	@echo "                     SETS=\"$(SETS)\""
	@echo
	@echo options:
	@echo "    make       - defaults to the 'setup' option."
	@echo "    make setup - generates the setup for a game of Mysterium."
	@echo "    make list  - list information about sets and game modes."
	@echo "    make help  - list make options."
	@echo
	@echo shuffle vision tips for good randomness:
	@echo "    riffle shuffle   - seven or eight passes."
	@echo "    overhand shuffle - about ten thousand passes."
	@echo "    strip shuffle    - at least two hundred passes."
	@echo "  * smoosh shuffle   - about one minute."
