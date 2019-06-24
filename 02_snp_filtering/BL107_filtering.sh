#!/bin/bash
#PBS -l mem=16gb,nodes=1:ppn=4,walltime=24:00:00
#PBS -m abe
#PBS -M wyant008@umn.edu
#PBS -q mesabi

set -e
set -o pipefail

# This script takes the raw SNP/indel calls from the 107 natural variation samples and performs quality filtering.

# This should come from sequence_handling's Variant_Recalibrator (subsetted to only BL107)
VCF=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/FN30cat/Variant_Recalibrator/FN30CAT_107.vcf

# The output directory
OUT_DIR=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/analysis/de_novo

# Load dependencies
module load bcftools/1.9
module load bedtools_ML/2.28.0 

# Make out directories
mkdir -p "${OUT_DIR}/intermediates"
mkdir -p "${OUT_DIR}/filtered"

cd "${OUT_DIR}"

(set -x;

# Remove variants that were flagged as poor quality by Variant_Recalibrator
grep -v "VQSRTrancheSNP99.90to100.00" "${VCF}" > "${OUT_DIR}/intermediates/BL107_noVQSRtranches.vcf"

# Zip and index the input files with bcftools
bcftools view -O z "${OUT_DIR}/intermediates/BL107_noVQSRtranches.vcf" > "${OUT_DIR}/intermediates/BL107_noVQSRtranches.vcf.gz"
bcftools index "${OUT_DIR}/intermediates/BL107_noVQSRtranches.vcf.gz"

# Filter the FN30
bcftools filter -S . -i 'QD > 20 & MQ >= 40 & FORMAT/GQ >= 10 & ((GT="RR" | GT="mis") | FORMAT/AD[*:1] > 2) & F_PASS(FORMAT/DP < 23) > 0.5 & FORMAT/DP < 23 & FS < 30' "${OUT_DIR}/intermediates/BL107_noVQSRtranches.vcf.gz" > "${OUT_DIR}/intermediates/BL107_filtered_int.vcf"
bcftools view -c 1:nref --exclude-uncalled -O z "${OUT_DIR}/intermediates/BL107_filtered_int.vcf" > "${OUT_DIR}/intermediates/BL107_withmis_filtered.vcf.gz"
bcftools index "${OUT_DIR}/intermediates/BL107_withmis_filtered.vcf.gz"

# Remove SNPs that have high missingness
bcftools filter -e "F_PASS(GT='mis') > 0.3" "${OUT_DIR}/intermediates/BL107_withmis_filtered.vcf.gz" > "${OUT_DIR}/intermediates/BL107_nomis_filtered.vcf"
bcftools view -c 1:nref --exclude-uncalled -O v "${OUT_DIR}/intermediates/BL107_nomis_filtered.vcf" > "${OUT_DIR}/filtered/BL107_final_filtered.vcf"
bcftools view -O z "${OUT_DIR}/filtered/BL107_final_filtered.vcf" > "${OUT_DIR}/filtered/BL107_final_filtered.vcf.gz"
bcftools index "${OUT_DIR}/filtered/BL107_final_filtered.vcf.gz"

# Make separate files for SNDs and SNIs
bcftools filter -i "STRLEN(REF) == 2 && STRLEN(ALT) == 1" "${OUT_DIR}/filtered/BL107_final_filtered.vcf" > "${OUT_DIR}/filtered/BL107_final_filtered_SNDs.vcf"
bcftools filter -i "STRLEN(REF) == 1 && STRLEN(ALT) == 2" "${OUT_DIR}/filtered/BL107_final_filtered.vcf" > "${OUT_DIR}/filtered/BL107_final_filtered_SNIs.vcf"

)
