# DENV_INS
Phylogenetic analysis and many others

## download nextclade datasets
´´´r
nextclade dataset get --name 'community/v-gen-lab/dengue/denv1' --output-dir denv1 ;
nextclade dataset get --name 'community/v-gen-lab/dengue/denv2' --output-dir denv2 ;
nextclade dataset get --name 'community/v-gen-lab/dengue/denv3' --output-dir denv3 ;
ls ;
´´´

## run nextclade 
´´´r
for s in *.fasta
do
seq=$(ls $s | sed 's/output_//g' | sed 's/.5.fasta//g')
nextclade run --input-dataset ${seq}/ --output-all ${seq}.nextclade $s --output-basename ${seq} --output-tsv ${seq}.nextclade/${seq}.nextclade.tsv --output-fasta ${seq}.nextclade/${seq}.nextclade.fasta
mv ${seq}.nextclade/${seq}.nextclade.tsv ${seq}.nextclade/${seq}.nextclade.fasta .
echo ${seq} as been done 
done 
ls ;
´´´
