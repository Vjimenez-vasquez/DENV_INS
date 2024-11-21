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

# DENV-1
d1 <- read.csv("metadata_nexstrain_denv1.tsv", header=T, sep="\t")
d1_ns <- read.csv("denv1.nextclade.tsv", header=T, sep="\t")
d1_ns1 <- data.frame(strain=d1_ns$seqName, clade=d1_ns$clade)
d1_f <- merge(d1,d1_ns1, by="strain", all.x=T)
dim(d1_f)
dim(d1)
write.table(d1_f, "metadata_nexstrain_denv1_ns.tsv", col.names=T, row.names=F, sep="\t", quot=F)

# DENV-2
d2 <- read.csv("metadata_nexstrain_denv2.tsv", header=T, sep="\t")
d2_ns <- read.csv("denv2.nextclade.tsv", header=T, sep="\t")
d2_ns1 <- data.frame(strain=d2_ns$seqName, clade=d2_ns$clade)
d2_f <- merge(d2,d2_ns1, by="strain", all.x=T)
dim(d2_f)
dim(d2)
write.table(d2_f, "metadata_nexstrain_denv2_ns.tsv", col.names=T, row.names=F, sep="\t", quot=F)

# DENV-3
d3 <- read.csv("metadata_nexstrain_denv3.tsv", header=T, sep="\t")
d3_ns <- read.csv("denv3.nextclade.tsv", header=T, sep="\t")
d3_ns1 <- data.frame(strain=d3_ns$seqName, clade=d3_ns$clade)
d3_f <- merge(d3,d3_ns1, by="strain", all.x=T)
dim(d3_f)
dim(d3)
write.table(d3_f, "metadata_nexstrain_denv3_ns.tsv", col.names=T, row.names=F, sep="\t", quot=F)
```

## nexststrain
```r

# 1: crear las carpetas "ns_denv1", "ns_denv2", "ns_denv3"
# 2: dentro de cada carpeta colocar los archivos "input" en cada caso (ejemplos: "auspice_config.json", "lat_longs.tsv", "denv3.gb", "raw_tree_denv3.nwk", "metadata_nextstrain_denv3_ns.tsv", "output_denv3.5.fasta")
# 3: fuera de las carpetas, también colocar los archivos "fasta" ("output_denv3.5.fasta", "output_denv2.5.fasta", "output_denv3.5.fasta")

# 4: 
conda activate nextstrain ;
for s in *.5.fasta
do
seq=$(ls $s | sed 's/output_//g' | sed 's/.5.fasta//g')
cd ns_${seq}/ ;
augur refine --alignment $s --tree raw_tree_${seq}.nwk --metadata metadata_nexstrain_${seq}_ns.tsv --output-tree refine_tree_${seq}.nwk --output-node-data node_Data.json --timetree --coalescent opt --gen-per-year 52 --root least-squares --covariance --date-confidence --date-inference marginal --branch-length-inference marginal --year-bounds 1950 2024 --divergence-units mutations-per-site --seed 12548746 ; 
augur ancestral --tree refine_tree_${seq}.nwk --alignment $s --output-node-data ancestral.json --inference marginal --keep-overhangs ; 
augur translate --tree refine_tree_${seq}.nwk --ancestral-sequences ancestral.json --reference-sequence ${seq}.gb --output-node-data translate.json ; 
augur traits --tree refine_tree_${seq}.nwk --metadata metadata_nexstrain_${seq}_ns.tsv --columns source country province serotype genotype result year clade --confidence --output-node-data traits.json ; 
AUGUR_RECURSION_LIMIT=10000 augur export v2 --tree refine_tree_${seq}.nwk --node-data ancestral.json node_Data.json traits.json translate.json --output final_${seq}.json --auspice-config auspice_config.json --geo-resolutions province --color-by-metadata source country province serotype change genotype seq result year clade --panels tree map entropy frequencies --metadata metadata_nexstrain_${seq}_ns.tsv --lat-longs lat_longs.tsv ;
mv final_${seq}.json .. ;
cd .. ;
echo nextstrain for ${seq} has been done 
done 
ls ;
```
