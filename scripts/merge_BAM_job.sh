#!/bin/sh

#PBS -l mem=8gb,nodes=1:ppn=16,walltime=12:00:00
#PBS -m abe
#PBS -M mfrodrig@umn.edu
#PBS -q lab

module load samtools

samtools merge finalBamFile.bam *.bam