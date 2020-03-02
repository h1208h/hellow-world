#!/bin/bash

for i in $(ls *.fasta)
do
	echo ${i}
	python 0.picrust2_header_v2.py ${i}
	python 1.make_tsv_v2.py ${i/.fasta}"_picrust2_header.fna"
	biom convert -i ${i/.fasta}"_picrust2_header_table.txt" -o ${i/.fasta}".biom" --table-type="OTU table" --to-json
	place_seqs.py -s ${i/.fasta}"_picrust2_header.fna" -o ${i/.fasta}_out.tre -p 5 --intermediate ${i/.fasta}_intermediate/place_seqs 2> ${i/.fasta}"_place_seqs.stderr"
	hsp.py -i 16S -t ${i/.fasta}_out.tre -o ${i/.fasta}_marker_predicted_and_nsti.tsv.gz -p 5 -n
	hsp.py -i EC -t ${i/.fasta}_out.tre -o ${i/.fasta}_EC_predicted.tsv.gz -p 5
	metagenome_pipeline.py -i ${i/.fasta}".biom" -m ${i/.fasta}"_marker_predicted_and_nsti.tsv.gz" -f ${i/.fasta}_EC_predicted.tsv.gz -o ${i/.fasta}_EC_metagenome_out --strat_out 2> ${i/.fasta}"_metagenome_pipeline.stderr"
	pathway_pipeline.py -i ${i/.fasta}_EC_metagenome_out/pred_metagenome_contrib.tsv.gz -o ${i/.fasta}_pathways_out -p 5
	add_descriptions.py -i ${i/.fasta}_EC_metagenome_out/pred_metagenome_unstrat.tsv.gz -m EC -o ${i/.fasta}_EC_metagenome_out/pred_metagenome_unstrat_descrip.tsv.gz
	add_descriptions.py -i ${i/.fasta}_pathways_out/path_abun_unstrat.tsv.gz -m METACYC -o ${i/.fasta}_pathways_out/path_abun_unstrat_descrip.tsv.gz
done
