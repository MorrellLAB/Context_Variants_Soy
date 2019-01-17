#!/bin/bash
#PBS -l mem=12gb,nodes=1:ppn=1,walltime=24:00:00
#PBS -m abe
#PBS -M wyant008@umn.edu
#PBS -q mesabi

module load bcftools/1.6

# This script isolates a single sample from the 107 baseline samples.
# The differences from reference in the single-sample VCF are 
# subtracted from the VCF of the treated lines.

# USER INPUT PARAMETERS:

# The location of the final VCF file for the 107 baseline samples
BASE_VCF=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/FN30cat/Variant_Filtering_107/FN30CAT_final.vcf

# The sample that is the genetic background for the fast neutron lines
NAME=M92-220.x1.04.WT_

# The location of the final VCF file for the 30 fast neutron lines
FN_VCF=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/FN30cat/Variant_Filtering/FN30CAT_final.vcf

# The output directory
OUTDIR=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/analysis/M92-220_subtraction

# BEGIN SCRIPT

cd "${OUTDIR}"

# Pull the one sample out of the baseline VCF, ignoring sites with only missing or reference calls
bcftools view -o "${OUTDIR}/${NAME}only.vcf" -s "${NAME}" -c 1:nref --exclude-uncalled "${BASE_VCF}"

# Compress and index the isolated vcf (required for bcftools isec)
bcftools convert -O z -o "${OUTDIR}/${NAME}only.vcf.gz" "${OUTDIR}/${NAME}only.vcf"
bcftools index "${OUTDIR}/${NAME}only.vcf.gz"

# Compress and index the treatment vcf (required for bcftools isec)
FNDIR=$(dirname ${FN_VCF})
bcftools convert -O z -o "${FNDIR}/FN30CAT_final.vcf.gz" "${FN_VCF}"
bcftools index "${FNDIR}/FN30CAT_final.vcf.gz"

# Take the 30 FN lines, and make a list of all sites present in the file generated in the last step
bcftools isec -C -O v -o "${OUTDIR}/FN30_de_novo_sites.tsv" "${FN_VCF}.gz" "${OUTDIR}/${NAME}only.vcf.gz"

# Subtract out the list of sites
bcftools view -R "${OUTDIR}/FN30_de_novo_sites.tsv" -o "${OUTDIR}/FN30_de_novo.vcf" "${FN_VCF}.gz"
