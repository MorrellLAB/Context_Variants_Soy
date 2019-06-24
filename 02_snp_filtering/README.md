# SNP Filtering Scripts
This directory contains scripts used to obtain, filter, and analyze *de novo* mutations.

### Inputs
- The VCF file of variants for the natural variation group, obtained from Variant\_Recalibrator in [01\_sequence\_handling](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling)
- The VCF file of variants for the treatment group, obtained from Variant\_Recalibrator in [01\_sequence\_handling](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling)
- The VCF file of variants for the genetic background line, obtained from Genotype_GVCFs in [01\_sequence\_handling](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling)
- The `dels.vcf.gz` and `large_sv_calls.bedpe` files obtained from running 10x Genomics' [Long Ranger](https://support.10xgenomics.com/genome-exome/software/pipelines/latest/output/overview) on the genetic background line

### Dependencies
- bcftools/1.9
- bedtools/2.28.0
- python3_ML/3.7.1_anaconda 
- vcfToBedpe [(from lumpy)](https://github.com/arq5x/lumpy-sv/blob/master/scripts/vcfToBedpe)

### Notebooks
Jupyter notebooks and scikit-allel were used to explore the quality metrics of each dataset (BL107, FN30, and M92-220). The per-sample maximum depth cutoff used in later filtering steps was determined to be the 95th percentile of depth across all samples and sites. All other filtering criteria remained constant across datasets. 

### Scripts


### Next Step: [03_context_analysis](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/03_context_analysis)