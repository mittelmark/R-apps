#!/usr/bin/env Rscript
#' 
#' NAME
#'
#'       Rcheck - Check properly formatted Rscripts with error reports for the line number
#' 
#' SYNOPSIS
#' 
#'       __APP__ [--help, -h] FILENAME
#' 
#' ARGUMENTS
#'
#'      FILENAME - Rscript file, properly formatted
#' 
#' OPTIONS
#'
#'      -h, --help        Display help page
#' 
#' DESCRIPTION
#'
#'       R does currently not supported showing error loclaization using for instance the
#'       the line number. This little script support reporting the line of the error if 
#'       your script is properly formatted. Evaluation will take place at the end of each 
#'       block which is indicated by starting with an opening curly bracet at the end of a
#'       line and ending at a closing curly bracket as the very first character of a line.
#'       Every line starting with a non-space, non-comment character is evaluated immediately.
#'
#' EXAMPLE
#' 
#'       The following code:
#'
#'       #!/usr/bin/env Rscript
#'       ## Test for bin/Rcheck.R
#'       x=3
#'       print(z)
#'       z=3
#'       print(z)
#'       print(a)
#' 
#'       Would produce the following error messages:
#'       
#'       Error bin/Rcheck-test.R:4:
#'       Objekt 'z' nicht gefunden 
#'       [1] 3
#'       Error bin/Rcheck-test.R:7:
#'       Objekt 'a' nicht gefunden 
#' 
#' AUTHOR
#'
#'      Detlef Groth, University of Potsdam, Germany
#'
#' LICENSE
#'
#'      MIT License
#' 
#' HOMEPAGE
#'
#'      https://github.com/mittelmark/R-apps
#'
# End of Help

#  TODO
#
#   - suppress print and cat terminal output
#   - more tests


evaluate_rscript <- function(file_path) {
    # Read the lines from the specified R script file
    lines <- readLines(file_path)
    flag = FALSE  
    # Initialize variables
    code_block <- ""
    
    # Loop over each line
    for (i in seq_along(lines)) {
        line <- lines[i]
        
        # Check if the line is empty or starts with a comment
        if (nchar(line) == 0 || grepl("^\\s*#", line)) {
            next  # Skip empty lines and comments
        }
    
        # Check if the line starts with whitespace
        if (grepl("^[[:space:]]", line)) {
            # If it's a continuation line, append to the current block
            code_block <- paste0(code_block, "\n", line)
        } else if (substr(line,1,1) == "}") {
           code_block <- paste0(code_block, "\n", line)
           tryCatch({
                  eval(parse(text = code_block))
              }, error = function(e) {
                 cat(sprintf("Error %s:%s:\n",file_path,i), e$message, "\n")
                 #break
              })
           code_block <- ""
       } else if (grepl("\\{\\s*$",line)) {
           code_block <- paste0(code_block, "\n", line)
       } else {
           code_block <- paste0(code_block, "\n", line)
           tryCatch({
                    eval(parse(text = code_block))
                }, error = function(e) {
                    cat(sprintf("Error %s:%s:\n",file_path,i), e$message, "\n")
                    #break
                })
           code_block <- ""
       }
   }
  
   # Evaluate any remaining code block after finishing the loop
   if (nchar(code_block) > 0) {
       tryCatch({
                eval(parse(text = code_block))
            }, error = function(e) {
                cat(sprintf("Error %s:%s:\n",file_path,i), e$message, "\n")
            })
   }
}
help <- function (argv) {
    fin  = file(argv[1], "r")
    while(length((line = readLines(fin,n=1)))>0) {
        if (grepl("^#'",line)) {
           cat(gsub("__APP__",argv[1],substr(line,3,nchar(line))),"\n")
        }
    }
    close(fin)
}
usage <- function (argv) {
   return(sprintf("Usage: %s [--help,-h] FILENAME\n",argv[1]))
}

main <- function (argv) {
    ## just appname 
    if (length(argv) == 1) {
        cat(usage(argv))
    } else {
        if (argv[2] %in% c("-h","--help")) {
            help(argv)
        } else if (length(argv) == 2) {
            if (file.exists(argv[2])) {
                evaluate_rscript(argv[2])
            } else {
                cat(sprintf("Error: File '%s' does not exists!",argv[2]))
                usage(argv)
            } 
        } else {
            ## unknown arguments
            cat("Error: Wrong number of arguments!")
            usage(argv)
        }
    }
}
if (sys.nframe() == 0L && !interactive()) {
    ## extract applications filename
    binname=gsub("--file=","",grep("--file",commandArgs(),value=TRUE)[1])
    main(c(binname,commandArgs(trailingOnly=TRUE)))
}



