#!/usr/bin/env Rscript
#' 
#' NAME
#'       calendar.R - Print 12 monthly calendars, either a generic one
#'                    or for a given year
#' 
#' SYNOPSIS
#'
#'       calendar.R [--help,-h] YEAR OUTFILE [DIR]
#' 
#' MANDATORY ARGUMENTS
#' 
#'      YEAR   - the year given with four digits like 2025, 
#'               if the year 0 is given a generic calendar 
#'               will be produced 
#'
#'      OUTFILE - the output file, must ending in pdf
#'
#' OPTIONAL ARGUMENTS
#'      
#'      DIR  - folder where the first 13 PNG images are taken as images
#'             on top of calendar if not given some random r-plots will
#'             be generated, if 14 images are in this folder then the last
#'             image is taken for the last page, 16
#'
#' OPTIONS
#' 
#'      -h, --help                     - display this help page
#'      -w  --weekdays Mon,Tue,Wed ... - list of seven weekdays, which should
#'                                       be show as abbreviations for real 
#'                                       year calendars
#' 
#' DESCRIPTION
#'
#'       This little R script allows you to create simple monthly calendars
#'       either for a given year or as generic calendars wihout date and weekday
#'       informations. The user can as well provide as well a folder with 13 or 14
#'       images. The first image is taken for the cover page, the optional 14th image
#'       is taken if available for the back cover. Both these images must be in portrait
#'       mode, aspect ratio very close to 1/2 width vs hight. 
#'       The other 12 images are taken as illustrative images on top of the monthly
#'       calendars, they must be in landscape mode with an aspect ratio of around 22/10.
#'       If the images are not in this apsect ratio they are currently scaled to fit that ratio.
#' 
#' AUTHOR
#'
#'      Detlef Groth, University of Potsdam, Germany
#'
#' LICENSE
#'      MIT License
#' 
#' HOMEPAGE
#'
#'      https://github.com/mittelmark/R-apps

library(png)
## fix for readline not working with Rscript
input <- function (prompt="Enter: ") {
    if (interactive() ){
        return(readline(prompt))
    } else {
        cat(prompt);
        return(readLines("stdin",n=1))
    }
}

## read help page on top
help <- function (argv) {
    fin  = file(argv[1], "r")
    while(length((line = readLines(fin,n=1)))>0) {
        if (grepl("^#'",line)) {
           cat(substr(line,3,nchar(line)),"\n")      
        }   
    }
    close(fin)
}
usage <- function (argv) {
   return(sprintf("Usage: %s [--help|-h] YEAR OUTFILE [DIR]\n",argv[1]))
}

main <- function (argv) {
    months=c("Januar","Februar","März","April",
             "Mai","Juni","Juli","August","September",
             "Oktober","November","Dezember")
    ## just appname 
    if (length(argv) == 1) {
        cat(usage(argv))
    } else  if (argv[2] %in% c("-h","--help")) {
        help(argv)
    } else if (length(argv) >= 3 ) {
        if (!grepl("^[0-9]+$",argv[2])) {
            cat(sprintf("Error: argument one '%s' must be a year given as a number or the number 0!!",argv[2]))
            usage(argv)
            return("")
        }
        if (!grepl(".pdf$",argv[3])) {
            cat(sprintf("Error: argument two '%s' must be a file name ending with the pdf extension!",argv[3]))
            usage(argv)
            return("")
        }
        files=c()
        if (length(argv) == 4) {
            if (!dir.exists(argv[4])) {
                cat(sprintf("Error: Directory '%s' does not exists!",argv[4]))
                return("")
            }
            files=list.files(argv[4],full.names=TRUE,pattern=".png")
            if (length(files) < 13) {
                cat(sprintf("Error: At leasz 13 png files must be in folder '%d'!"),argv[4])
                return("")
            }
        }
        pdf(argv[3],width=10.5/2.54,height=21.6/2.54)
        par(mai=c(0.0,0.1,0.0,0.0))
        j=0
        plot(1,type="n",xlab="",ylab="",axes=FALSE,xlim=c(0,2),ylim=c(0,21))
        img=readPNG(files[j+1])
        rasterImage(img,0,21,2,0)
        par(mai=c(0.1,0.1,0.1,0.4))
        plot(1,type="n",xlab="",ylab="",axes=FALSE,xlim=c(0,2),ylim=c(0,21))
        text(1,18,"Notizen",cex=2)
        for (i in 16:1) {
            lines(c(0,2),c(i,i),lwd=2)
        }
        cat("Processing ... ")
        for (i in c(31,29,31,30,31,30,31,31,30,31,30,31)) {
            cat(sprintf("# %i ",j))
            j=j+1
            if (j %% 2 == 1) {
                par(mai=c(0.1,0.4,0.1,0.1))
            } else {
                par(mai=c(0.1,0.1,0.1,0.4))
            }
            
            img=readPNG(files[j+1])
            plot(1,type="n",xlab="",ylab="",axes=FALSE,xlim=c(0,2),ylim=c(0,21))
            rasterImage(img,0,17,2,21)
            lines(c(1,1),c(15.5,-0.5),lwd=2)
            text(2,16.2,months[j],pos=2,cex=2)
            y=15
            k=0
            while (k < i) {
                if (k < 16) {
                    x=0
                    xt=0
                    pos=4
                } else {
                    x=1
                    xt=2
                    pos=2
                }
                if (k==16) {
                    y=15
                }
                
                text(xt,y,k+1,pos=pos)
                lines(c(x,x+1),c(y+0.5,y+0.5),lwd=2)
                k=k+1
                y=y-1
                if (k == 16 | k == i) {
                    lines(c(x,x+1),c(y+0.5,y+0.5),lwd=2)
                }
            }
        }
        par(mai=c(0.1,0.4,0.1,0.1))
        plot(1,type="n",xlab="",ylab="",axes=FALSE,xlim=c(0,2),ylim=c(0,21))
        text(1,18,"Notizen",cex=2)
        for (i in 16:1) {
            lines(c(0,2),c(i,i),lwd=2)
        }
        
        plot(1,type="n",xlab="",ylab="",axes=FALSE,xlim=c(0,2),ylim=c(0,21))            
        
        dev.off()
        cat("done!\n")
    } else {
        ## unknown argument
        cat(sprintf("Error: Unknown argument '%s'!",argv[2]))
    }
    cat(sprintf("Success: File '%s' written!\n",argv[3]))
}
if (sys.nframe() == 0L && !interactive()) {
    ## extract applications filename
    binname=gsub("--file=","",grep("--file",commandArgs(),value=TRUE)[1])
    main(c(binname,commandArgs(trailingOnly=TRUE)))
}
