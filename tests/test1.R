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
