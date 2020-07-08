package main

import (
	"flag";
	"fmt";
	"os";
	"path";
	"strconv";
)

import (
	"red-gpwd/internal";
)

var VERSION = "v0.3.2"

//----------------------------------------------------------------------------//

func error_and_exit(format string, args ...interface{}) {
	fmt.Fprintf(os.Stderr, "<!> " + format, args...)
	os.Exit(1)
}

func contains_linear(arg string, arr []string) bool {
	for _, val := range arr {
		if arg == val {
			return true
		}
	}

	return false
}

//----------------------------------------------------------------------------//

func main() {
	//declare options
	opts_entropy_name := "e"
	opts_mode_name := "m"
	opts_modes := []string {
		"base64-url",
		"base32",
		"eff-long",
		"eff-short",
		"eff-short-pre",
	}

	//define cli flags
	flag.CommandLine.SetOutput(os.Stderr)
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr,
			"Usage: %v <symbol-length/OR/entropy-value>\n" +
			"Version: %v\n\n" +
			"Randomly generates a password. Available modes:\n" +
			"    base64-url   : Base64 based password (64 symbols)\n" +
			"    base32       : Base32 based password (32 symbols)\n" +
			"    eff-long     : Electronic Fronter Foundation's long word list. (7,776 symbols)\n" +
			"    eff-short    : Electronic Fronter Foundation's short list using smaller words. (1,296 symbols)\n" +
			"    eff-short-pre: Electronic Fronter Foundation's short list using unique prefixes. (1,296 symbols)\n\n" +
			"Options:\n",
			path.Base(os.Args[0]),
			VERSION,
		)
		flag.PrintDefaults()
	}

	opt_mode := flag.String(
		opts_mode_name,
		opts_modes[0],
		fmt.Sprintf("Specify generation mode %v.", opts_modes))
	opt_entropy := flag.Bool(
		opts_entropy_name,
		false,
		"If set, input specifies an entropy goal instead of symbol length.")
	flag.Parse()

	//validate flags
	if !contains_linear(*opt_mode, opts_modes) {
		error_and_exit(
			"Invalid input '%v' for option '%v'\n",
			*opt_mode, opts_mode_name)
		}

	//validate input
	args := flag.Args()
	if len(args) != 1 {
		if len(args) == 0 {
			flag.Usage()
			os.Exit(1)
		} else {
			error_and_exit(
				"Invalid input for '%v', expected 1 argument got %v\n",
				*opt_mode,
				len(args))
		}
	}

	input_value, err := strconv.Atoi(args[0])
	if err != nil {
		error_and_exit(
			"Invalid input '%v' for mode '%v', value is not an integer\n",
			args[0],
			*opt_mode)
	}

	result, err := internal.CreatePassword(*opt_mode, input_value, *opt_entropy)
	if err != nil {
		error_and_exit(err.Error())
	}

	fmt.Println(result)
}
