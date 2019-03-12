#!/bin/bash

# QSUB PBS definitions, in order
# send message (email below) if abort/begining job/exit happens
# which computer I'm submiting job to
# we are requesting 1 entire node (24 ppn is the whole node)

#PBS -m abe
#PBS -M mfrodrig@umn.edu
#PBS -q lab
#PBS -l mem=24gb,nodes=1:ppn=16,walltime=6:00:00

md5sum /panfs/roc/scratch/fernanda/USDA_BRAG_2nd_seq_batch/*.gz > hash_value_downloaded_files

md5sum /panfs/roc/data_release/1/umgc/morrellp/novaseq/190131_A00223_0077_AHC7C3DSXX/Morrell_Project_008/*.gz > /panfs/roc/scratch/fernanda/USDA_BRAG_2nd_seq_batch/hash_value_original_files