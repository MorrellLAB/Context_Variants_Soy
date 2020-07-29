#!/bin/bash -l
#PBS -l nodes=1:ppn=1,mem=4gb,walltime=18:00:00
#PBS -m abe
#PBS -M pmorrell@umn.edu
#PBS -A morrellp
#PBS -W group_list=morrellp
#PBS -q mesabi

module load htslib/1.9
module load perl/modules.centos7.5.26.1

#    Variant sets should be either 'all', deletions', 'insertions', 'snps', 'common', or 'rare'
VARIANT_SET=rare

cd /panfs/roc/groups/9/morrellp/pmorrell/Workshop/Context_of_Mutations

/home/morrellp/shared/Software/ensembl-vep-release-97.3/vep \
    -i /panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/analysis/de_novo/filtered/BL107_final_filtered_nomis_rare.vcf \
    --gff /scratch.global/pmorrell/Context_of_Mutations/Gmax_275_Wm82.a2.v1.gene_exons_sorted.gff3.gz \
    --fasta /panfs/roc/groups/9/morrellp/shared/References/Reference_Sequences/Soybean/PhytozomeV11/Gmax/assembly/Gmax_275_v2.0.fa \
    --species glycine_max \
    --total_length \
    --check_svs \
    --verbose \
    --format vcf \
    --force \
    --warning_file BL107_vep_err_${VARIANT_SET}.txt \
    -o BL107_VeP_${VARIANT_SET}.txt
