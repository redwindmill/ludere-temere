REDWINDILL PASSWORD GENERATOR (RGPWD)
================================================================
A password generator that supports [DICEWARE](https://www.eff.org/dice) based passwords.

```
Usage: rgpwd <symbol-length/OR/entropy-value>
Version: v0.3.2

Randomly generates a password. Available modes:
    base64-url   : Base64 based password (64 symbols)
    base32       : Base32 based password (32 symbols)
    eff-long     : Electronic Fronter Foundation's long word list. (7,776 symbols)
    eff-short    : Electronic Fronter Foundation's short list using smaller words. (1,296 symbols)
    eff-short-pre: Electronic Fronter Foundation's short list using unique prefixes. (1,296 symbols)

Options:
  -e	If set, input specifies an entropy goal instead of symbol length.
  -m string
        Specify generation mode [base64-url base32 eff-long eff-short eff-short-pre]. (default "base64-url")
```
