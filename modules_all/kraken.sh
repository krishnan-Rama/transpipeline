#!/bin/bash

#SBATCH --job-name=pipeline
#SBATCH --partition=gpu       # the requested queue
#SBATCH --nodes=1              # number of nodes to use
#SBATCH --tasks-per-node=1     #
#SBATCH --cpus-per-task=1      #
#SBATCH --mem-per-cpu=70000     # in megabytes, unless unit explicitly stated

echo "Some Usable Environment Variables:"
echo "================================="
echo "hostname=$(hostname)"
echo "\$SLURM_JOB_ID=${SLURM_JOB_ID}"
echo "\$SLURM_NTASKS=${SLURM_NTASKS}"
echo "\$SLURM_NTASKS_PER_NODE=${SLURM_NTASKS_PER_NODE}"
echo "\$SLURM_CPUS_PER_TASK=${SLURM_CPUS_PER_TASK}"
echo "\$SLURM_JOB_CPUS_PER_NODE=${SLURM_JOB_CPUS_PER_NODE}"
echo "\$SLURM_MEM_PER_CPU=${SLURM_MEM_PER_CPU}"

# Write jobscript to output file (good for reproducibility)
cat $0

module load kraken2/2.1.1
module load seqtk/1.3
# module load krona/2.8

krakendir="/mnt/scratch/c23048124/pipeline_all/workdir/kraken_all/kraken_Gbull"
trimdir="/mnt/scratch/c23048124/pipeline_all/workdir/trim_files_2/trim_Gbull"

echo "Starting Kraken2 analysis..."

echo ${trimdir}

file=$(ls ${trimdir}/*_1.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)

R1=$(basename $file | cut -f1 -d.)
base=$(echo $R1 | sed 's/_1$//')

kraken2 --paired --db /mnt/scratch/nodelete/smbpk/kraken/kraken_db/kraken_standard \
  --output ${krakendir}/${base}_kraken2_output \
  --report ${krakendir}/${base}_kraken2_report \
  --classified-out ${krakendir}/${base}_#.classified.fastq \
  --unclassified-out ${krakendir}/${base}_#.unclassified.fastq \
  --threads ${SLURM_CPUS_PER_TASK} \
  ${trimdir}/${base}_1.fastq.gz ${trimdir}/${base}_2.fastq.gz

module unload kraken2/2.1.1
module unload seqtk/1.3
