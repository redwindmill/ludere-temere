#!/usr/bin/env python
#pylint: disable=W0312,C0111,C0330,R0913,C0326

import argparse
import json
import os
import sys
import random

MIN_CRIMES		= 4
SPECIAL_CONTEXT	= 'notes'
RULES_CONTEXTS	= ['setup', 'ghost', 'psychics', SPECIAL_CONTEXT]
FMT_KEY_SETUP	= '%s_%d'

REQUIRED_FIELDS_SET		= ['id', 'setup', 'rules', 'cards']
REQUIRED_FIELDS_SETUP	= ['players', 'mode', 'kinds', 'num_cards']
REQUIRED_FIELDS_RULES	= ['phase', 'context', 'mode', 'players', 'difficulties', 'rule']
REQUIRED_FIELDS_CARDS	= ['id', 'kind', 'set']

#------------------------------------------------------------------------------#

def report(fmt, *arg):
	sys.stdout.write(fmt % arg)

def parse_json(path_json, required_fields):
	blob = None

	with open(path_json) as file_json:
		blob = json.load(file_json)

		#TODO:: not much validation happening
		for elem in blob:
			for field in required_fields:
				if field not in elem:
					raise ValueError(
						"'%s' missing required field '%s'" % (path_json, field))

	return blob

#------------------------------------------------------------------------------#

def report_info_cards(kind, list_cards):
	report("\n%s cards:\n", kind)
	report("    total: %d\n", len(list_cards))
	sets = {}

	for card in list_cards:
		key = card['set']
		list_set = sets.get(key)

		if not list_set:
			list_set = []
			sets[key] = list_set

		list_set.append(card)

	keys = sorted(sets.keys())
	for key in keys:
		report("    %s: %d\n", key, len(sets[key]))

def report_psychic_cards(kinds, dealt_by_kind):
	report("\npsychic cards:\n")

	for kind in kinds:
		ids = []
		for card in dealt_by_kind[kind]:
			ids.append("%4s" % (card['id']))

		report("    %-9s: %s\n", kind, " ".join(sorted(ids)))

def report_mode_rules(mode_rules, note):
	report(note)

	#sort by phase
	rules_by_phase = {}
	for rule in mode_rules:
		key = rule['phase']
		list_rules = rules_by_phase.get(key)
		if not list_rules:
			list_rules = []
			rules_by_phase[key] = list_rules

		list_rules.append(rule)

	#TODO:: special casing context, seems bad
	list_phases = sorted(rules_by_phase.keys())
	set_context = set(RULES_CONTEXTS)

	for phase in list_phases:
		rules = rules_by_phase[phase]

		#sort by context
		rules_by_context = {}
		for rule in rules:
			key = rule['context']

			if key not in set_context:
				key = SPECIAL_CONTEXT

			list_rules = rules_by_context.get(key)
			if not list_rules:
				list_rules = []
				rules_by_context[key] = list_rules

			list_rules.append(rule['rule'])

		#report by context
		report("\nrules phase %s:\n", phase)
		for key in RULES_CONTEXTS:
			list_rules = rules_by_context.get(key)
			if not list_rules:
				continue

			for rule in list_rules:
				report("    %s\n", rule)
			report("\n")

def report_crimes(crimes, num_players, murderer):
	counter = 0
	report("\ncrimes:\n")

	for crime in crimes:
		counter += 1

		pid = '-'
		if counter <= num_players:
			pid = str(counter)

		guilty = ' '
		if counter == murderer:
			guilty = '*'

		report("  %s%2s : %s\n", guilty, pid, " ".join(crime))

#------------------------------------------------------------------------------#

def parse_sets(path_sets, list_sets):
	data_sets = parse_json(path_sets, REQUIRED_FIELDS_SET)
	path_data = os.path.dirname(path_sets)

	setups = {}
	rules = {}
	cards = {}
	available_sets = []

	#TODO:: Naively parsing files by set.
	#TODO:: We will potentially parse the same file more than once.
	#TODO:: This should not be an issue given the small number of cards.
	for data in data_sets:
		key = data['id']
		available_sets.append(key)

		if key in list_sets:
			#parse setups
			path_setup = data['setup']
			if path_setup:
				blob = parse_json(
					os.path.join(path_data, path_setup),
					REQUIRED_FIELDS_SETUP)

				for setup in blob:
					key = FMT_KEY_SETUP % (setup['mode'], setup['players'])
					setups[key] = setup

			#parse rules
			path_rules = data['rules']
			if path_rules:
				blob = parse_json(
					os.path.join(path_data, path_rules),
					REQUIRED_FIELDS_RULES)

				for rule in blob:
					key = rule['mode']
					list_rules = rules.get(key)
					if not list_rules:
						list_rules = []
						rules[key] = list_rules

					list_rules.append(rule)

			#parse cards
			list_path_cards = data['cards']
			if list_path_cards:
				for path_cards in list_path_cards:
					blob = parse_json(
						os.path.join(path_data, path_cards),
						REQUIRED_FIELDS_CARDS)

					for card in blob:
						if not card['set'] in list_sets:
							continue

						key = card['kind']
						list_cards = cards.get(key)
						if not list_cards:
							list_cards = []
							cards[key] = list_cards

						list_cards.append(card)

	available_sets = sorted(list(set(available_sets)))
	return available_sets, setups, rules, cards

def report_info(
	available_sets, setups_by_mode_player, cards_by_kind, mode, num_players, difficulty):
	report("available sets: %s\n", " ".join(available_sets))

	#report setup
	key_setup = FMT_KEY_SETUP % (mode, num_players)
	setup = setups_by_mode_player.get(key_setup)
	report("\n%s settings for '%d' players on '%s':\n", mode, num_players, difficulty)

	if setup:
		report("    cards: %d\n", setup['num_cards'][difficulty])
		report("    kinds: %s\n", ' '.join(setup['kinds']))
	else:
		report("missing\n")

	#report cards
	kinds = sorted(cards_by_kind.keys())
	for key in kinds:
		report_info_cards(key, cards_by_kind[key])

def gen_setup(setups, cards_by_kind, mode, num_players, difficulty):
	key_setup = FMT_KEY_SETUP % (mode, num_players)
	setup = setups[key_setup]

	num_cards = setup['num_cards'][difficulty]
	kinds = setup['kinds']

	dealt_by_kind = {}
	for kind in kinds:
		if kind not in cards_by_kind.keys():
			raise ValueError("missing card kind '%s'" % (kind))

		list_cards = cards_by_kind[kind]
		len_cards = len(list_cards)
		if len_cards < num_cards:
			raise ValueError("not enough cards '%d/%d'" % (num_cards, len_cards))

		random.shuffle(list_cards)
		dealt_by_kind[kind] = list_cards[:num_cards] #random.sample(list_cards, num_cards)

	return kinds, dealt_by_kind

def gen_rules(rules_by_mode, mode, num_players, difficulty):
	rules = []
	for rule in rules_by_mode[mode]:
		if num_players not in rule['players']:
			continue

		if difficulty not in rule['difficulties']:
			continue

		rules.append(rule)

	return rules

def gen_crimes(kinds, dealt_by_kind, num_players):
	results = []
	max_crimes = max(num_players, MIN_CRIMES)

	for i in range(0, max_crimes):
		results.append([])

	for kind in kinds:
		ids = []
		for card in dealt_by_kind[kind]:
			ids.append(card['id'])

		random.shuffle(ids)
		ids = ids[:max_crimes]

		counter = 0
		for uid in ids:
			list_crime = results[counter]
			value = "%s %-5s" % (kind, uid)
			list_crime.append(value)
			counter += 1

	return results

def gen_murderer(num_players):
	max_crimes = max(num_players, MIN_CRIMES)
	murderer = random.randint(1, max_crimes)

	return murderer

def main(args):
	random.seed()
	note = \
		"\n    This setup is for %d players on %s.\n" % (args.num_players, args.difficulty)

	available_sets, \
	setups_by_mode_player, \
	rules_by_mode, \
	cards_by_kind = parse_sets(args.json_sets, args.list_sets)

	if args.action_list:
		report_info(
			available_sets,
			setups_by_mode_player,
			cards_by_kind,
			args.mode,
			args.num_players,
			args.difficulty)
		return

	kinds, \
	dealt_by_kind = gen_setup(
		setups_by_mode_player,
		cards_by_kind,
		args.mode,
		args.num_players,
		args.difficulty)

	mode_rules = gen_rules(rules_by_mode, args.mode, args.num_players, args.difficulty)
	crimes = gen_crimes(kinds, dealt_by_kind, args.num_players)
	murderer = gen_murderer(args.num_players)

	report_psychic_cards(kinds, dealt_by_kind)
	report_crimes(crimes, args.num_players, murderer)
	report_mode_rules(mode_rules, note)

	report("\n")

#------------------------------------------------------------------------------#

if __name__ == "__main__":
	PARSER = argparse.ArgumentParser(
		description='Generates the setup for a game of Mysterium.'
	)

	PARSER.add_argument(
		'json_sets',
		help='Path to json file containing Mysterium card sets.',
	)

	PARSER.add_argument(
		'-l', '--list',
		action='store_true',
		dest='action_list',
		default=False,
		help='List information about sets and game modes.'
	)

	PARSER.add_argument(
		'-p', '--players',
		action='store',
		dest='num_players',
		type=int,
		choices=[2, 3, 4, 5, 6, 7],
		required=True,
		help='Number of players in the game.'
	)

	PARSER.add_argument(
		'-d', '--difficulty',
		action='store',
		dest='difficulty',
		type=str,
		choices=['easy', 'normal', 'hard', 'insane', 'nightmare'],
		required=True,
		help='Difficulty of the game.'
	)

	PARSER.add_argument(
		'-m', '--mode',
		action='store',
		dest='mode',
		type=str,
		default='original',
		help='Game mode to generate.'
	)

	PARSER.add_argument(
		'-s', '--sets',
		action='store',
		dest='list_sets',
		type=str,
		default=['base'],
		nargs='+',
		help='List of sets to include.'
	)

	ARGS = PARSER.parse_args()
	main(ARGS)
