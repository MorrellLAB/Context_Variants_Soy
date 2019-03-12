#!/bin/bash

# Only run from inside the COUNTS_TABLES directory
# Usage: create_plots.sh <output_directory>

# This is not a super well-coded piece of work, sorry
# But hopefully it does the job

module load python3_ML/3.6.4

# Import the argument
OUTDIR="$1"
mkdir -p "${OUTDIR}"

# Make subdirectories
mkdir -p "${OUTDIR}/AtoG" "${OUTDIR}/AtoC" "${OUTDIR}/AtoT"
mkdir -p "${OUTDIR}/CtoG" "${OUTDIR}/CtoA" "${OUTDIR}/CtoT"
mkdir -p "${OUTDIR}/GtoA" "${OUTDIR}/GtoC" "${OUTDIR}/GtoT"
mkdir -p "${OUTDIR}/TtoG" "${OUTDIR}/TtoC" "${OUTDIR}/TtoA"

# Grab the input files
A=$(ls AtoG*)
B=$(ls AtoC*)
C=$(ls AtoT*)
D=$(ls CtoG*)
E=$(ls CtoA*)
F=$(ls CtoT*)
G=$(ls GtoA*)
H=$(ls GtoC*)
I=$(ls GtoT*)
J=$(ls TtoA*)
K=$(ls TtoG*)
L=$(ls TtoC*)

# Generate some plots
mutation_analysis nbr -1 "${A}" -o "${OUTDIR}/AtoG"
mutation_analysis nbr -1 "${B}" -o "${OUTDIR}/AtoC"
mutation_analysis nbr -1 "${C}" -o "${OUTDIR}/AtoT"
mutation_analysis nbr -1 "${D}" -o "${OUTDIR}/CtoG"
mutation_analysis nbr -1 "${E}" -o "${OUTDIR}/CtoA"
mutation_analysis nbr -1 "${F}" -o "${OUTDIR}/CtoT"
mutation_analysis nbr -1 "${G}" -o "${OUTDIR}/GtoA"
mutation_analysis nbr -1 "${H}" -o "${OUTDIR}/GtoC"
mutation_analysis nbr -1 "${I}" -o "${OUTDIR}/GtoT"
mutation_analysis nbr -1 "${J}" -o "${OUTDIR}/TtoA"
mutation_analysis nbr -1 "${K}" -o "${OUTDIR}/TtoG"
mutation_analysis nbr -1 "${L}" -o "${OUTDIR}/TtoC"