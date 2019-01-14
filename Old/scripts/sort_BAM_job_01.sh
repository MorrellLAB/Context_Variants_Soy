#!/bin/sh

#PBS -l mem=6gb,nodes=1:ppn=16,walltime=6:00:00
#PBS -m abe
#PBS -M mfrodrig@umn.edu
#PBS -q lab

module load samtools

samtools sort -O bam -o /panfs/roc/scratch/fernanda/FN30/SAM_Processing/SAMtools/Sorted_BAM/reheader/merged/M92-220.x1.04.WT_sorted.bam /panfs/roc/scratch/fernanda/FN30/SAM_Processing/SAMtools/Sorted_BAM/reheader/merged/M92-220.x1.04.WT.bam

