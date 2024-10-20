# DENV_INS
Phylogenetic analysis and many others

## download nextclade datasets
```r
nextclade dataset get --name 'community/v-gen-lab/dengue/denv1' --output-dir denv1 ;
nextclade dataset get --name 'community/v-gen-lab/dengue/denv2' --output-dir denv2 ;
nextclade dataset get --name 'community/v-gen-lab/dengue/denv3' --output-dir denv3 ;
ls ;
```

## run nextclade 
```r
for s in *.fasta
do
seq=$(ls $s | sed 's/output_//g' | sed 's/.5.fasta//g')
nextclade run --input-dataset ${seq}/ --output-all ${seq}.nextclade $s --output-basename ${seq} --output-tsv ${seq}.nextclade/${seq}.nextclade.tsv --output-fasta ${seq}.nextclade/${seq}.nextclade.fasta
mv ${seq}.nextclade/${seq}.nextclade.tsv ${seq}.nextclade/${seq}.nextclade.fasta .
echo ${seq} has been done 
done 
ls ;
```

## merge metadata and nextclade results
```r
setwd("C:/Users/HP/Documents/dengue/DENV_2024")
getwd()
dir()

d1 <- read.csv("metadata_nexstrain_denv1.tsv", header=T, sep="\t")
d1_ns <- read.csv("denv1.nextclade.tsv", header=T, sep="\t")
d1_ns1 <- data.frame(strain=d1_ns$seqName, clade=d1_ns$clade)
d1_f <- merge(d1,d1_ns1, by="strain", all.x=T)
dim(d1_f)
dim(d1)
write.table(d1_f, "metadata_nexstrain_denv1_ns.tsv", col.names=T, row.names=F, sep="\t", quot=F)

d2 <- read.csv("metadata_nexstrain_denv2.tsv", header=T, sep="\t")
d2_ns <- read.csv("denv2.nextclade.tsv", header=T, sep="\t")
d2_ns1 <- data.frame(strain=d2_ns$seqName, clade=d2_ns$clade)
d2_f <- merge(d2,d2_ns1, by="strain", all.x=T)
dim(d2_f)
dim(d2)
write.table(d2_f, "metadata_nexstrain_denv2_ns.tsv", col.names=T, row.names=F, sep="\t", quot=F)

d3 <- read.csv("metadata_nexstrain_denv3.tsv", header=T, sep="\t")
d3_ns <- read.csv("denv3.nextclade.tsv", header=T, sep="\t")
d3_ns1 <- data.frame(strain=d3_ns$seqName, clade=d3_ns$clade)
d3_f <- merge(d3,d3_ns1, by="strain", all.x=T)
dim(d3_f)
dim(d3)
write.table(d3_f, "metadata_nexstrain_denv3_ns.tsv", col.names=T, row.names=F, sep="\t", quot=F)
```
