#!/bin/sh

#PBS -l mem=15gb,nodes=1:ppn=4,walltime=24:00:00
#PBS -m abe
#PBS -M mfrodrig@umn.edu
#PBS -q lab

module load parallel

./fixBAMHeader.sh -t FN30_sample_names_unix.txt -p ILLUMINA -s sortedBAM.txt