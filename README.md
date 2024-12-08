# R-apps

R one file applications useful standalone or as part of your own package.

## Applications

The following applications are provided:

- [Rcheck.R](bin/Rcheck.R) - check your R applications reporting lines of errors

## Examples

### Rcheck

```bash
user@micky R-apps]$ cat -n tests/Rcheck-test.R 
     1	#!/usr/bin/env Rscript
     2	## Test for bin/Rcheck.R
     3	x=3
     4	print(z)
     5	z=3
     6	print(z)
     7	print(a)

[user@micky R-apps]$ Rscript bin/Rcheck.R tests/Rcheck-test.R 
Error tests/Rcheck-test.R:4:
 Objekt 'z' nicht gefunden 
[1] 3
Error tests/Rcheck-test.R:7:
 Objekt 'a' nicht gefunden 
```

## Installation

Just download the script from the  repository,  make it executable and move it
to a folder  belonging to your PATH  variable. On my Linux  machine that looks
like this:

```bash
wget https://raw.githubusercontent.com/mittelmark/R-apps/refs/heads/main/bin/Rcheck.R \
    -O ~/.local/bin/Rcheck
chmod 755 ~/.local/bin/Rcheck
Rcheck 
# ...
# Usage: /home/user/.local/bin/Rcheck [--help,-h] FILENAME
'''

## License

MIT

## Author

Detlef Groth, University of Potsdam, Germany


