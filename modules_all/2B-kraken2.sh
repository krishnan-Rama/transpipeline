#!/bin/bash

reportdir="/mnt/scratch/c23048124/pipeline_all/workdir/kraken_all/kraken_report"

# Load necessary modules and activate virtual environment
python -m venv python_kraken2
source ${moduledir}/python_kraken/python_kraken2/bin/activate

sbatch --job-name=pipeline --output=${krakendir}/G_bull.out --error=${krakendir}/G_bull.err \
		--ntasks=1 --cpus-per-task=4 --mem=16G --partition=jumbo \
		--wrap="${moduledir}/extract_kraken_reads.py \
		-k ${krakendir}/Gbull_020823_trim_kraken2_output \
		-s1 ${trimdir}/Gbull_020823_trim_1.fastq.gz \
		-s2 ${trimdir}/Gbull_020823_trim_2.fastq.gz \
		-r ${krakendir}/Gbull_020823_trim_kraken2_report \
		--exclude --include-parents --taxid 2 \
		-o ${krakendir}/Gbull_020823_1.fastq \
		-o2 ${krakendir}/Gbull_020823_2.fastq"

# Deactivate virtual environment and unload modules
deactivate
