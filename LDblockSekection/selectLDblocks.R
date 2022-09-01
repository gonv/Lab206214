#!/usr/bin/env Rscript

library("optparse")
library("dplyr")
library("tidyr")

args = commandArgs(trailingOnly=TRUE)
table <- read.table(args[1],header=T,stringsAsFactors = F, na.strings = "unknown" , sep="\t", as.is=T)
pval <- args[2]

#META <- read.table("/home/gonv/MR/META_GWAS_SSc_NGyNEW_4_DEF_5PC_noHLA.meta.clean",header=T,stringsAsFactors = F, na.strings = "unknown" , sep="\t", as.is=T)

table$logP <- round(as.numeric(-log10(table$P)),20)

filename <- as.character(args[1])

META_1e5 <- table %>% filter(table$logP > pval)

pdf <- data.frame(META_1e5 %>% select(starts_with("SNP")))

f=1
p<-ceiling(length(pdf[,1])/99)
for (i in 1:p){
  seq=seq(f, f+98)
  f=99*i
  file=paste(filename, as.character(i), ".txt", sep='')
  qdf <- pdf[seq,]
  write.table(as.vector(na.omit(qdf)), file=file, row.names = F, quote = F, col.names=F, sep = "\t")
}
