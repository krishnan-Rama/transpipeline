#!/bin/bash

#SBATCH --job-name=pipeline
#SBATCH --partition=epyc       # the requested queue
#SBATCH --nodes=1              # number of nodes to use
#SBATCH --tasks-per-node=1     #
#SBATCH --cpus-per-task=4      #
#SBATCH --mem-per-cpu=1000     # in megabytes, unless unit explicitly stated

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

module load fastp/v0.20

echo "Starting Fastp analysis..."

# script needs to have rawdir and trimdir defined and exported

echo ${rawdir}

file=$(ls ${rawdir}/*_1.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)

R1=$(basename $file | cut -f1 -d.)
base=$(echo $R1 | sed 's/_1$//')  

fastp -i "${rawdir}/${base}_1.fastq.gz" -I "${rawdir}/${base}_2.fastq.gz" \
  -o "${trimdir}/${base}_trim_1.fastq.gz" -O "${trimdir}/${base}_trim_2.fastq.gz" \
  --cut_front --cut_tail --cut_window_size 4 --cut_mean_quality 30 \
  --qualified_quality_phred 30 --unqualified_percent_limit 30 \
  --n_base_limit 5 --length_required 60 --detect_adapter_for_pe \
  -h "${qcdir}/${base}_fastp.html" -j "${qcdir}/${base}_fastp.json" \
  -w ${SLURM_CPUS_PER_TASK}
