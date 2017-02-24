#!/bin/sh

#PBS -l mem=8gb,nodes=1:ppn=16,walltime=12:00:00
#PBS -m abe
#PBS -M mfrodrig@umn.edu
#PBS -q lab

module load parallel

cd /panfs/roc/scratch/fernanda/FN30/SAM_Processing/SAMtools/Sorted_BAM/

./fixBAMHeader.sh -t /panfs/roc/scratch/fernanda/FN30/SAM_Processing/SAMtools/Sorted_BAM/FN30_sample_names_unix.txt -p ILLUMINA -s /panfs/roc/scratch/fernanda/FN30/SAM_Processing/SAMtools/Sorted_BAM/sortedBAM.txt
