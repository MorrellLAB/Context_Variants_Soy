# SNP Filtering Scripts
A collection of scripts used to obtain the *de novo* mutations for each treatment group.

### Inputs
- A quality-filtered VCF file of all SNPs for the treatment group, obtained from Variant\_Filtering in [01\_sequence\_handling]()
- An unfiltered VCF file of all SNPs for the genetic background line, obtained from Variant\_Recalibrator in [01\_sequence\_handling]()
- The soybean reference genome, version 2.0
- The `dels.vcf.gz`, `large_sv_calls.bedpe`, and `phased_variants.vcf.gz` files obtained from running 10x Genomics' [Long Ranger](https://support.10xgenomics.com/genome-exome/software/pipelines/latest/output/overview) on the genetic background line

### Dependencies
- bcftools/1.6
- python3
    - scikit-allel
    - numpy

### Scripts
- 01_background_subtraction.sh
- 02_snp_counts.py
- 03_10xvcf_to_bedpe.py
- 04_bedpe_to_bed.sh
- 05_deletion_filtering.sh
- 06_make_py_dict.sh
- 07_plot_windowed_pi.py
- 08_get_high_pi_regions.py
- 09_heterogeneity_filtering.sh
- 02_snp_counts.py

### Next Step: [03_context_analysis]()