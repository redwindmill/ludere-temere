package internal

import (
	"strings";
	"testing";
)

var TEST_WORDS = []string {
	"01", "02", "03", "04", "05", "06", "07", "08",
	"11", "12", "13", "14", "15", "16", "17", "18",
	"21", "22", "23", "24", "25", "26", "27", "28",
	"31", "32", "33", "34", "35", "36", "37", "38",
	"41", "42", "43", "44", "45", "46", "47", "48",
	"51", "52", "53", "54", "55", "56", "57", "58",
	"61", "62", "63", "64", "65", "66", "67", "68",
	"71", "72", "73", "74", "75", "76", "77",
}

func TestByCount(t *testing.T) {
	for i:=0; i<COUNT_MAX; i++ {
		count := i+1
		v32, _ := generateBase32ByCount(count)
		v64, _ := generateBase64URLByCount(count)
		vWD, _ := generateWordsByCount(TEST_WORDS, count)

		if len(v32) != count {
			t.Errorf("Base32 result length failed for '%v'", count)
		}

		if len(v64) != count {
			t.Errorf("Base64URL result length failed for '%v'", count)
		}

		tmp := strings.Split(vWD, " ")
		if len(tmp) != count {
			t.Errorf("Word result length failed for '%v'", count)
		}
	}
}
