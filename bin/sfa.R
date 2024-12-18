#!/usr/bin/env Rscript
HELP = "
sfa.R - building R single file applications 

SYNOPSIS

```{.bash}
sfa.R ?-h,--help? FILE1.R FILE2.R ... ?-o OUTFILE.R?
```
 
DESCRIPTION

This a command line tool which allows you to build single file applications 
from several R files if they follow certain conventions used in the course
Introduction to Databases and Practical Programming at the University of Potsdam. 

These conventions are the followings: if the R files have possible functions
help, usage or/and main they should come after the actual class or function 
definitions, a block to check for the name check of the application must be
at the very end. These definitions are kept for the last file given on the
command line but removed for for all files given before in the command line.

The tool concatanates in principle all the given files to a single file.
However it removes all source statements from the files to import other files
code giving on the command line. It as well stops concatanating for the
current file, if it is not the last file, if a function like usage, main or
help is seen on the current line. As well only for the last file the
main/name check is kept. 

EXAMPLE

```{.bash}
sfa.R infile1.R infile2.R infile2.R -o appfile.R
chmod 755 appfile.R
cp appfile.R ~/.local/bin/appfile
appfile -h
```
"


usage <- function (argv) {
    cat("sfa.R - Building single Rscript file applications\n")
    cat("Author: Detlef Groth, University of Potsdam\n")
    cat("License: MIT\n-----------------------------------------\n")
    cat("Usage: sfa.R FILE1.R FILE2.R ... ?-o OUTFILE.R?\n")

}
main <- function (argv) {
    outfile <- ""
    if (length(argv) == 1) {
        usage(argv)
    } else if ("-h" %in% argv | "--help" %in% argv) {
        hlp=gsub("\n([A-Z]{2}[A-Z ]+)","\n\033[33m\\1\033[0m",HELP)
        hlp=gsub("\n```\\{.bash\\}","\033[34m",hlp)
        hlp=gsub("\n```","\033[0m",hlp)        
        cat("\033[33mNAME\033[0m\n")
        cat(hlp)
    } else {
        if ("-o" %in% argv) {
            idx = which(argv == "-o")[1]
            if (length(argv)>idx) {
                outfile=argv[idx+1]
                argv=argv[-c(idx,idx+1)]
            } else {
                cat("Error: Missing output filename after -o option!\n")
                q()
            }
        }
        files = c()
        if (length(argv) == 2) {
            cat("Error: At least two Python input files are required!\n")
            usage(argv)
            q()
        }
        for (arg in argv[2:length(argv)]) {
            if (!file.exists(arg)) {
                cat(sprintf("Error: File '%s' does not exists!",arg))
                usage(argv)
                q()
            } else {
                files = c(files,arg)
            }
        }
        if (outfile != "") {
            out  = file(outfile,'w')
            cat("#!/usr/bin/env Rscript\n",file=out)
        } else {
            cat("#!/usr/bin/env Rscript\n")
        }
        for (i in 1:length(files)) {
            fin = file(files[i],'r')
            if (outfile != "") {
                cat(sprintf("# file: %s\n",files[i]),file=out)
            } else {
                cat(sprintf("# file: %s}\n",files[i]))
            }
            while(length((line = readLines(fin,n=1)))>0) {
                if (grepl("^#!/",line)) {
                    next
                } else if (grepl("^source",line)) {
                    next
                }
                if (files[i] != files[length(files)]) {
                    if (grepl("(usage|help|main).+function",line)) {
                        break
                    } else if (grepl("^if.+sys.nframe",line)) {
                        break
                    }
                }
                if (grepl("^\\s*#'",line)) {
                    next
                }
                if (outfile != "") {
                    cat(line, "\n",file=out)        
                } else {
                    cat(line, "\n")
                }
            }
            close(fin)
        }
        if (outfile != "") {
            close(out)
        }
    }
}        


if (sys.nframe() == 0L && !interactive()) {
    binname=gsub("--file=","",grep("--file",commandArgs(),value=TRUE)[1])
    main(c(binname,commandArgs(trailingOnly=TRUE)))
}
