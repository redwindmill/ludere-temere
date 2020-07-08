package data

import (
	"testing";
)

func TestListSize(t *testing.T) {
	var name string;
	var words []string;
	var len_exp int;

	name = "eff-long"
	words = EFF_LONG_WORDS
	len_exp = EFF_LONG_WORDS_EXPECTED_LEN
	if len(words) != len_exp {
		t.Errorf("%v word list length was '%v', expected '%v'",
			name, len(words), len_exp)
	}

	name = "eff-short"
	words = EFF_SHORT_WORDS
	len_exp = EFF_SHORT_WORDS_EXPECTED_LEN
	if len(words) != len_exp {
		t.Errorf("%v word list length was '%v', expected '%v'",
			name, len(words), len_exp)
	}

	name = "eff-short-pre"
	words = EFF_SHORT_PRE_WORDS
	len_exp = EFF_SHORT_PRE_WORDS_EXPECTED_LEN
	if len(words) != len_exp {
		t.Errorf("%v word list length was '%v', expected '%v'",
			name, len(words), len_exp)
	}
}

func hasDuplicates(list []string) bool {
	unique := map[string]bool {}

	for _, value := range list {
		if _, ok := unique[value]; ok {
			return true
		} else {
			unique[value] = true
		}
	}

	return false
}

func TestListForDuplicates(t *testing.T) {
	var name string;
	var words []string;

	name = "eff-long"
	words = EFF_LONG_WORDS
	if hasDuplicates(words) {
		t.Errorf("%v word list has duplicate values", name)
	}

	name = "eff-short"
	words = EFF_SHORT_WORDS
	if hasDuplicates(words) {
		t.Errorf("%v word list has duplicate values", name)
	}

	name = "eff-short-pre"
	words = EFF_SHORT_PRE_WORDS
	if hasDuplicates(words) {
		t.Errorf("%v word list has duplicate values", name)
	}
}
