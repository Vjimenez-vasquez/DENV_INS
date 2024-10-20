conda activate nextstrain ; 
augur refine --alignment output_denv1.5.fasta --tree raw_tree_denv1.nwk --metadata metadata_nexstrain_denv1_ns.tsv --output-tree refine_tree_denv1.nwk --output-node-data node_Data.json --timetree --coalescent opt --gen-per-year 52 --root least-squares --covariance --date-confidence --date-inference marginal --branch-length-inference marginal --year-bounds 1950 2024 --divergence-units mutations-per-site --seed 12548746 ; 
augur ancestral --tree refine_tree_denv1.nwk --alignment output_denv1.5.fasta --output-node-data ancestral.json --inference marginal --keep-overhangs ; 
augur translate --tree refine_tree_denv1.nwk --ancestral-sequences ancestral.json --reference-sequence denv1.gb --output-node-data translate.json ; 
augur traits --tree refine_tree_denv1.nwk --metadata metadata_nexstrain_denv1_ns.tsv --columns source country province serotype genotype result year clade --confidence --output-node-data traits.json ; 
AUGUR_RECURSION_LIMIT=10000 augur export v2 --tree refine_tree_denv1.nwk --node-data ancestral.json node_Data.json traits.json translate.json --output final_denv1.json --auspice-config auspice_config.json --geo-resolutions province --color-by-metadata source country province serotype change genotype seq result year clade --panels tree map entropy frequencies --metadata metadata_nexstrain_denv1_ns.tsv --lat-longs lat_longs.tsv ; 
ls -lh ; 

output_denv1.5.fasta
denv1.gb
lat_longs.tsv
raw_tree_denv1.nwk
metadata_nexstrain_denv1_ns.tsv


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