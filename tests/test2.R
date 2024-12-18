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
