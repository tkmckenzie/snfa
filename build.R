setwd("C:/Users/Taylor/Dropbox/Research/SNFA/snfa_package/snfa")

devtools::build()

system("R CMD Rd2pdf --force --output=../snfa.pdf --no-preview .")
