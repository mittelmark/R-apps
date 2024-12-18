# R-apps

R one file applications useful standalone or as part of your own package.

## Applications

The following applications are provided:

- [Rcheck.R](bin/Rcheck.R) - check your R applications reporting lines of errors
- [sfa.R](bin/sfa.R) - build single file R scripts out of a set of several R scripts

## Examples

### Rcheck.R

```bash
[user@micky R-apps]$ cat -n tests/Rcheck-test.R 
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

## sfa.R - single file application creator

Often the user would like to concatanate a set of R scripts into a single file
to  forward  the script to an other user as an easy to use  application  which
just needs to be copied to a folder  within the users `PATH`. The script sfa.R
removes  all usage and main  functions  as well the main block for all given R
script  files  except  for the last file  which is  considered  to be the main
script.  Furthermore  all source  calls are removed as it expected  that these
files are all combined in the output file in the right order. Example:

```
[user@micky bin]$ head -n 15 ../tests/test*R
==> ../tests/test1.R <==
#!/usr/bin/env Rscript

test1 <- function () {
  print("test1")
}
main <- function (argv) {
    print("Hi")
    test1()
}
if (sys.nframe() == 0L && !interactive()) {
    main(commandArgs(trailingOnly=TRUE))
}

==> ../tests/test2.R <==
#!/usr/bin/env Rscript

source("test1.R")

test2 <- function () {
  print("test2")
}
main <- function (argv) {
    print("Hi")
    test1()
    test2()
}
if (sys.nframe() == 0L && !interactive()) {
    main(commandArgs(trailingOnly=TRUE))
}
[user@micky bin]$ Rscript sfa.R ../tests/*.R -o app.R
[user@micky bin]$ cat app.R  ## the combined file
#!/usr/bin/env Rscript
# file: ../tests/test1.R
 
test1 <- function () { 
  print("test1") 
} 
# file: ../tests/test2.R
 
 
test2 <- function () { 
  print("test2") 
} 
main <- function (argv) { 
    print("Hi") 
    test1() 
    test2() 
} 
if (sys.nframe() == 0L && !interactive()) { 
    main(commandArgs(trailingOnly=TRUE)) 
} 

[user@micky bin]$ Rscript app.R 
[1] "Hi"
[1] "test1"
[1] "test2"
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
## ...
## Usage: /home/user/.local/bin/Rcheck [--help,-h] FILENAME
wget https://raw.githubusercontent.com/mittelmark/R-apps/refs/heads/main/bin/sfa.R \
    -O ~/.local/bin/sfa.R
chmod 755 ~/.local/bin/sfa.R
Rscript sfa.R 
## sfa.R - Building single Rscript file applications
## Author: Detlef Groth, University of Potsdam
## License: MIT
## -----------------------------------------
## Usage: sfa.R FILE1.R FILE2.R ... ?-o OUTFILE.R?
```

## License

MIT - License

## Author 

@ Detlef Groth, University of Potsdam, Germany, 2024


