package internal

import (
	"crypto/rand";
	"encoding/base32";
	"encoding/base64";
	"fmt";
	"math";
	"math/big";
	"strings";
)

import (
	"red-gpwd/internal/data";
)

var COUNT_MAX = 512
var ENTROPY_MAX = 1024

//----------------------------------------------------------------------------//

func randomBytes(arg int) []byte {
	bytes := make([]byte, arg)
	_, err := rand.Read(bytes)
	if err != nil {
		panic(err)
	}

	return bytes
}

func randomInt(max *big.Int) int {
	value, err := rand.Int(rand.Reader, max)
	if err != nil {
		panic(err)
	}

	return int(value.Int64())
}

func convertEntropyToCount(arg int, units int) int {
	entropyPerUnit := math.Log2(float64(units))
	desiredCount := float64(arg)/entropyPerUnit

	return int(math.Ceil(desiredCount))
}

func convertBaseCountToBytes(arg int, baseBits int) int {
	desiredBytes := float64(arg*baseBits)/8.0

	return int(math.Ceil(desiredBytes))
}

//----------------------------------------------------------------------------//

func generateBase32Based(arg int, byEntropy bool) (string, error) {
	if byEntropy {
		arg = convertEntropyToCount(arg, 32)
	}

	return generateBase32ByCount(arg)
}

func generateBase32ByCount(count int) (string, error) {
	bytes := randomBytes(convertBaseCountToBytes(count, 5))

	result := base32.StdEncoding.EncodeToString(bytes)
	result = strings.ReplaceAll(result, "=", "")
	return result[0:count], nil //truncate is safe (we over estimate bytes)
}

//----------------------------------------------------------------------------//

func generateBase64URLBased(arg int, byEntropy bool) (string, error) {
	if byEntropy {
		arg = convertEntropyToCount(arg, 64)
	}

	return generateBase64URLByCount(arg)
}

func generateBase64URLByCount(count int) (string, error) {
	bytes := randomBytes(convertBaseCountToBytes(count, 6))

	result := base64.URLEncoding.EncodeToString(bytes)
	result = strings.ReplaceAll(result, "=", "")
	return result[0:count], nil //truncate is safe (we over estimate bytes)
}

//----------------------------------------------------------------------------//

func generateWordBased(words []string, arg int, byEntropy bool) (string, error) {
	if byEntropy {
		arg = convertEntropyToCount(arg, len(words))
	}

	return generateWordsByCount(words, arg)
}

func generateWordsByCount(words []string, count int) (string, error) {
	var sb strings.Builder
	max := big.NewInt(int64(len(words)))

	for i:=0; i<count; i++ {
		idx := randomInt(max)

		_, err := sb.WriteString(words[idx])
		if err != nil {
			panic(err)
		}

		err = sb.WriteByte(' ')
		if err != nil {
			panic(err)
		}
	}

	result := strings.TrimSpace(sb.String())
	return result, nil
}

//----------------------------------------------------------------------------//

func CreatePassword(mode string, arg int, byEntropy bool) (string, error) {
	if byEntropy == false {
		if arg < 1 || arg > COUNT_MAX {
			return "", fmt.Errorf("Invalid symbol value '%v', expected in range [1,%v]\n",
				arg, COUNT_MAX)
		}
	} else {
		if arg < 1 || arg > ENTROPY_MAX {
			return "", fmt.Errorf("Invalid entropy value '%v', expected in range [1,%v]\n",
				arg, ENTROPY_MAX)
		}
	}

	switch mode {
	case "base32":
		return generateBase32Based(arg, byEntropy)
	case "base64-url":
		return generateBase64URLBased(arg, byEntropy)
	case "eff-long":
		return generateWordBased(data.EFF_LONG_WORDS, arg, byEntropy)
	case "eff-short":
		return generateWordBased(data.EFF_SHORT_WORDS, arg, byEntropy)
	case "eff-short-pre":
		return generateWordBased(data.EFF_SHORT_PRE_WORDS, arg, byEntropy)
	default:
		return "", fmt.Errorf("Mode '%v' is undefined\n", mode)
	}
}
