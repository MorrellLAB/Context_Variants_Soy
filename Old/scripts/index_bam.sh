#!/bin/bash

#PBS -l mem=22gb,nodes=1:ppn=16,walltime=12:00:00
#PBS -m abe
#PBS -M liux1299@umn.edu
#PBS -q lab

set -e
set -u
set -o pipefail

#   Define usage message
#   Note: The following paths to arguments will need to be hardcoded \n\
    #   1. [bamFile_list] is a list of bam files to be indexed
    #   2. [bamFile_dir] is where our BAM files are located

#   Dependencies
module load samtools
module load parallel

#   Function to index bam files
function indexBAM() {
    local BAMFile="$1"
    local out_dir="$2"
    #   Sample name
    sampleName=`basename "${BAMFile}" .bam`
    #   Create BAI index for BAM file
    samtools index -b "${out_dir}/${sampleName}.bam"
}

#   Export function
export -f indexBAM

#   Arguments provided by user
#   list of bam files
BAM_LIST=/panfs/roc/scratch/liux1299/WBDC_Inversions_Project/seq_handling_parts_ref/WBDC_100bp/SAM_Processing/Picard/Finished/WBDC_100bp_finished_bam.txt
#   where are our BAM files located?
#   Make sure there is no slash at the end of this path
#   Slash at the end will cause error
OUT_DIR=/panfs/roc/scratch/liux1299/WBDC_Inversions_Project/seq_handling_parts_ref/WBDC_100bp/SAM_Processing/Picard/Finished

#   Do the work
parallel indexBAM {} "${OUT_DIR}" :::: "${BAM_LIST}"
