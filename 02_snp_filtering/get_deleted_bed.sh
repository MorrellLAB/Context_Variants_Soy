#!/bin/bash
#PBS -l mem=16gb,nodes=1:ppn=4,walltime=24:00:00
#PBS -m abe
#PBS -M wyant008@umn.edu
#PBS -q mesabi

set -e
set -o pipefail

# This script takes the output from Long Ranger and creates a single BED file with all deleted regions.

# The BEDPE file of large structural variants called by Long Ranger
LSV_CALLS=/panfs/roc/groups/9/morrellp/shared/Datasets/10x_Genomics/Soybean/m92_220/large_sv_calls.bedpe

# The VCF file of short deletions called by Long Ranger
DELS=/panfs/roc/groups/9/morrellp/shared/Datasets/10x_Genomics/Soybean/m92_220/dels.vcf.gz

# The script to convert a 10x Genomics VCF to bedpe format
SCRIPT=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/analysis/10x_analysis/vcfToBedpe_stolen_from_lumpy.py

# The output directory
OUTDIR=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/analysis/10x_analysis

module load python3_ML/3.7.1_anaconda 
module load bcftools/1.9
module load bedtools_ML/2.28.0 

# Make and cd into the output directory
mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

# Convert to bedpe format
bcftools view -O v "${DELS}" > "${OUTDIR}/dels.vcf"
python3 "${SCRIPT}" "${OUTDIR}/dels.vcf" > "${OUTDIR}/dels.bedpe"

# Convert to bed format
grep -v "#" "${LSV_CALLS}" | grep "TYPE=DEL" | awk -F "\t" '{ OFS="\t"; print $1, $2, $6}' > "${OUTDIR}/large_sv_calls_dels.bed"
grep -v "#" "${OUTDIR}/dels.bedpe" | awk -F "\t" '{ OFS="\t"; print $1, $2, $6}' > "${OUTDIR}/dels.bed"

# Combine the deletions
cat "${OUTDIR}/dels.bed" "${OUTDIR}/large_sv_calls_dels.bed" > "${OUTDIR}/merged_dels.bed"

# Sort the intervals, then collapse overlapping intervals
sort -k1,1 -k2,2n "${OUTDIR}/merged_dels.bed" > "${OUTDIR}/merged_dels_sorted.bed"
bedtools merge -i "${OUTDIR}/merged_dels_sorted.bed" > "${OUTDIR}/merged_dels_collapsed.bed"

#awk '{diff+=$3-$2} END {print diff}' merged_dels_collapsed.bed
#36935633

#python
#>>> (36935633)/965821250
#0.038242721414547466

# Deletions span roughly 4% of the mappable genome!
