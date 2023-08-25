#!/bin/bash
#SBATCH --job-name=pipeline
#SBATCH --partition=epyc       # the requested queue
#SBATCH --nodes=1              # number of nodes to use
#SBATCH --tasks-per-node=1     #
#SBATCH --cpus-per-task=16     #   
#SBATCH --mem=36000            # in megabytes, unless unit explicitly stated


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

module load blast/2.12.0

declare -a blastlib=(\
sprot
Hsap
Mmus
Dmel
Cele
Scer
)

blastp -query  "${evigenedir}/okayset/${assembly}.okay.aa" \
       -db "${blastdb}/${blastlib[${SLURM_ARRAY_TASK_ID}]}" \
       -num_threads ${SLURM_CPUS_PER_TASK} \
       -max_target_seqs 1 \
       -evalue 1E-10 \
       -outfmt 6 \
       -out "${blastout}/${assembly}_${blastlib[${SLURM_ARRAY_TASK_ID}]}_blp.tsv"
