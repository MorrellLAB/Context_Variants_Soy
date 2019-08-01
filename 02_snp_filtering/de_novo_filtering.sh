#!/bin/bash
#PBS -l mem=8gb,nodes=1:ppn=4,walltime=24:00:00
#PBS -m abe
#PBS -M wyant008@umn.edu
#PBS -q mesabi

set -e
set -o pipefail

# This script takes the raw SNP/indel calls from M92-220 and the FN30 treatment lines and performs filtering and subtraction to get a set of de novo variants.

# This should come from sequence_handling's Variant_Recalibrator (subsetted to only FN30)
TRMT_VCF=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/FN30cat/Variant_Recalibrator/FN30CAT_30.vcf

# This should be a combined VCF made from the parts output by sequence_handling's Genotype_GVCFs
GB_VCF=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/M92-220/Genotype_GVCFs/M92-220_complete.vcf

# The output directory
OUT_DIR=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/analysis/de_novo

# The bed file of deleted regions in M92-220
DEL_BED=/panfs/roc/groups/9/morrellp/shared/Datasets/10x_Genomics/Soybean/m92_220/merged_dels_collapsed.bed

# List of good samples to keep
GOOD_SAMPS=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/analysis/de_novo/good_samps.list

# The final, filtered, zipped VCF of the baseline 107
BL107=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/analysis/de_novo_old/filtered/BL107_final_filtered_nomis.vcf.gz

# Load dependencies
module load bcftools/1.9
module load bedtools_ML/2.28.0 

# Make out directories
mkdir -p "${OUT_DIR}/intermediates"
mkdir -p "${OUT_DIR}/filtered"

cd "${OUT_DIR}"

(set -x;

# Remove variants that were flagged as poor quality by Variant_Recalibrator
grep -v "VQSRTrancheSNP99.90to100.00" "${TRMT_VCF}" > "${OUT_DIR}/intermediates/FN30_noVQSRtranches.vcf"

# Zip and index the input files with bcftools
bcftools view -O z "${OUT_DIR}/intermediates/FN30_noVQSRtranches.vcf" > "${OUT_DIR}/intermediates/FN30_noVQSRtranches.vcf.gz"
bcftools view -O z "${GB_VCF}" > "${OUT_DIR}/intermediates/M92-220_complete.vcf.gz"
bcftools index "${OUT_DIR}/intermediates/FN30_noVQSRtranches.vcf.gz"
bcftools index "${OUT_DIR}/intermediates/M92-220_complete.vcf.gz"

# Filter the FN30
bcftools filter -S . -i 'QD > 20 & MQ >= 40 & FORMAT/GQ >= 10 & ((GT="RR" | GT="mis") | FORMAT/AD[*:1] > 2) & F_PASS(FORMAT/DP < 43) > 0.5 & FORMAT/DP < 43 & FS < 30' "${OUT_DIR}/intermediates/FN30_noVQSRtranches.vcf.gz" > "${OUT_DIR}/intermediates/FN30_filtered_int.vcf.gz"
bcftools view -c 1:nref --exclude-uncalled -O z "${OUT_DIR}/intermediates/FN30_filtered_int.vcf.gz" > "${OUT_DIR}/intermediates/FN30_final_filtered.vcf.gz"
bcftools index "${OUT_DIR}/intermediates/FN30_final_filtered.vcf.gz"

# Filter M92-220
bcftools filter -S . -i 'QD > 20 & MQ >= 40 & FORMAT/GQ >= 10 & ((GT="RR" | GT="mis") | FORMAT/AD[*:1] > 2) & F_PASS(FORMAT/DP < 121) > 0.5 & FORMAT/DP < 121 & FS < 30' "${OUT_DIR}/intermediates/M92-220_complete.vcf.gz" > "${OUT_DIR}/intermediates/M92-220_filtered_int.vcf.gz"
bcftools view -c 1:nref --exclude-uncalled -O z "${OUT_DIR}/intermediates/M92-220_filtered_int.vcf.gz" > "${OUT_DIR}/filtered/M92-220_final_filtered.vcf.gz"
bcftools index "${OUT_DIR}/filtered/M92-220_final_filtered.vcf.gz"

# Perform subtraction
bcftools isec -C -O v -o "${OUT_DIR}/intermediates/FN30_de_novo_sites.tsv" "${OUT_DIR}/intermediates/FN30_final_filtered.vcf.gz" "${OUT_DIR}/filtered/M92-220_final_filtered.vcf.gz"
bcftools view -R "${OUT_DIR}/intermediates/FN30_de_novo_sites.tsv" -o "${OUT_DIR}/intermediates/FN30_de_novo_raw.vcf" "${OUT_DIR}/intermediates/FN30_final_filtered.vcf.gz"

# Remove 3 outlier lines
bcftools view -S "${GOOD_SAMPS}" -c 1:nref --exclude-uncalled -O v -o "${OUT_DIR}/intermediates/FN27_de_novo_unsorted.vcf" "${OUT_DIR}/intermediates/FN30_de_novo_raw.vcf"
bcftools sort "${OUT_DIR}/intermediates/FN27_de_novo_unsorted.vcf" > "${OUT_DIR}/intermediates/FN27_de_novo.vcf"
bcftools view -O z -o "${OUT_DIR}/intermediates/FN27_de_novo.vcf.gz" "${OUT_DIR}/intermediates/FN27_de_novo.vcf"
bcftools index "${OUT_DIR}/intermediates/FN27_de_novo.vcf.gz"

# Filter out SNPs in regions where M92-220 has a deletion relative to reference
bedtools intersect -v -a "${OUT_DIR}/intermediates/FN27_de_novo.vcf.gz" -b "${DEL_BED}" > "${OUT_DIR}/intermediates/FN27_de_novo_no_dels.vcf"

# Reheader the file, since bedtools doesn't preserve the VCF header
grep "#" "${OUT_DIR}/intermediates/FN27_de_novo.vcf" > "${OUT_DIR}/intermediates/FN27_de_novo_no_dels_reheader.vcf"
cat "${OUT_DIR}/intermediates/FN27_de_novo_no_dels.vcf" >> "${OUT_DIR}/intermediates/FN27_de_novo_no_dels_reheader.vcf"

# Filter out sites with greater than 30% missing entries
bcftools filter -e 'F_PASS(GT="mis") > 0.3' "${OUT_DIR}/intermediates/FN27_de_novo_no_dels_reheader.vcf" > "${OUT_DIR}/intermediates/FN27_de_novo_nomis.vcf"

# Do some fancy 'singleton' filtering
# This only allows multitons in lines that are related to one another
bcftools filter -e 'N_PASS(GT[0,7-26]="het" | GT[0,7-26]="AA") > 1 | (N_PASS(GT[1-3]="AA" | GT[1-3]="het") > 0 && N_PASS(GT[0, 4-26]="het" | GT[0, 4-26]="AA") > 0) | (N_PASS(GT[4-6]="AA" | GT[4-6]="het") > 0 && N_PASS(GT[0-3, 7-26]="het" | GT[0-3, 7-26]="AA") > 0)' "${OUT_DIR}/intermediates/FN27_de_novo_nomis.vcf" > "${OUT_DIR}/intermediates/FN27_de_novo_single_rough.vcf"

# Collapse unused alternate alleles and remove monomorphic sites
bcftools view -a -c 1:nref "${OUT_DIR}/intermediates/FN27_de_novo_single_rough.vcf" > "${OUT_DIR}/intermediates/FN27_de_novo_single.vcf"

# Filter to only biallelic sites
bcftools view -m2 -M2 "${OUT_DIR}/intermediates/FN27_de_novo_single.vcf" > "${OUT_DIR}/intermediates/FN27_de_novo_single_bia.vcf"

# Now filter for only homozygotes
bcftools filter -e "GT='het'" "${OUT_DIR}/intermediates/FN27_de_novo_single_bia.vcf" > "${OUT_DIR}/intermediates/FN27_singhom.vcf"
bcftools view -O z -o "${OUT_DIR}/intermediates/FN27_singhom.vcf.gz" "${OUT_DIR}/intermediates/FN27_singhom.vcf"
bcftools index "${OUT_DIR}/intermediates/FN27_singhom.vcf.gz"

# Remove any sites found to be segregating in the BL107
bcftools isec -p "${OUT_DIR}/intermediates/" "${OUT_DIR}/intermediates/FN27_singhom.vcf.gz" "${BL107}"
bcftools view -O z -o "${OUT_DIR}/intermediates/0002.vcf.gz" "${OUT_DIR}/intermediates/0002.vcf"
bcftools index "${OUT_DIR}/intermediates/0002.vcf.gz"
bcftools isec -C -O v -o "${OUT_DIR}/intermediates/FN27_isec.tsv" "${OUT_DIR}/intermediates/FN27_singhom.vcf.gz" "${OUT_DIR}/intermediates/0002.vcf.gz"
bcftools view -R "${OUT_DIR}/intermediates/FN27_isec.tsv" -o "${OUT_DIR}/intermediates/FN27_singhom_isec.vcf" "${OUT_DIR}/intermediates/FN27_singhom.vcf.gz"

# Remove duplicate sites
bcftools norm -d all "${OUT_DIR}/intermediates/FN27_singhom_isec.vcf" > "${OUT_DIR}/FN27_de_novo_final.vcf"

# Make separate files for SNDs and SNIs
bcftools filter -i "STRLEN(REF) == 2 && STRLEN(ALT) == 1" "${OUT_DIR}/FN27_de_novo_final.vcf" > "${OUT_DIR}/FN27_de_novo_final_SNDs.vcf"
bcftools filter -i "STRLEN(REF) == 1 && STRLEN(ALT) == 2" "${OUT_DIR}/FN27_de_novo_final.vcf" > "${OUT_DIR}/FN27_de_novo_final_SNIs.vcf"

)
