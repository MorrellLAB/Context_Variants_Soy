# SNP Filtering Scripts
A collection of scripts used to obtain the *de novo* mutations for each treatment group.

### Inputs
- A quality-filtered VCF file of all SNPs for the treatment group, obtained from Variant\_Filtering in [01\_sequence\_handling](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling)
- An unfiltered VCF file of all SNPs for the genetic background line, obtained from Variant\_Recalibrator in [01\_sequence\_handling](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling)
- The `dels.vcf.gz`, `large_sv_calls.bedpe`, `large_sv_candidates.bedpe`, and `phased_variants.vcf.gz` files obtained from running 10x Genomics' [Long Ranger](https://support.10xgenomics.com/genome-exome/software/pipelines/latest/output/overview) on the genetic background line

### Dependencies
- bcftools/1.6
- python3/3.6.4
    - scikit-allel
    - numpy
    - matplotlib
- bedtools

### Scripts
- `01_background_subtraction.sh`: This script removes all polymorphic sites in the genetic background line from the VCF files of sites detected in the treatment group.
- `02_snp_counts.py`: This script outputs the number of missing, heterozygous, and homozygous-alternative sites on a per-individual basis. It was used to check for outliers in the total number of sites with an alternative allele. Individuals that have a much higher (10-20x higher) number of sites with an alternative allele are likely not the same genetic background as the rest of the treatment group. These individuals were removed from the treatment VCF file using bcftools.
- `03_10xvcf_to_bedpe.py`: This script is a modified version of [this lumpy script](https://github.com/arq5x/lumpy-sv/blob/master/scripts/vcfToBedpe). It converts a VCF file from 10x Genomics, which can have the breakpoints of a structural variant listed as separate sites each with an uncertainty in position, into a bedpe file. This was used on the `dels.vcf.gz` file obtained from running 10x Genomics' [Long Ranger](https://support.10xgenomics.com/genome-exome/software/pipelines/latest/output/overview) on the genetic background line.
- `04_bedpe_to_bed.sh`: This contains the commands used to convert a [bedpe](https://support.10xgenomics.com/genome-exome/software/pipelines/latest/output/bedpe) file into a regular bed file. Breakpoints are chosen so as to maximize the size of the structural variant (ie: start1 and stop2 are chosen as positions). This was used on `dels.vcf.gz`, the deletion variants from `large_sv_candidates.bedpe`, and the deletion variants from `large_sv_calls.bedpe`. Afterwards, the bed files were combined and the intervals were merged with bedtools merge to create a single bed file with the locations of all deletions in the genetic background line.
- `05_deletion_filtering.sh`: bcftools was used to filter out all polymorphic sites called in the deleted regions bed file created in step 4.
- `06_plot_windowed_pi.py`: This script takes a VCF file and uses `soybean_contigs_dict.py` to output plots of pi in windows across each chromosome and across the genome as a whole. Coupled with visualization using IGV, these plots can be used to determine the optimal window size and pi threshold needed to detect heterogeneity via elevated pi. 
- `07_get_high_pi_regions.py`: After determining the optimal window size and pi threshold from the previous step, this script was used to output a bed file containing regions with pi above the specified threshold.
- `08_heterogeneity_filtering.sh`: bedtools was used to remove all polymorphic sites in the treatment VCF called in the regions denoted by the bed file generated last step.
- `02_snp_counts.py`: This script was run again to check for outliers with an unusually high number of heterozygotes (10-20x). Samples with pervasive runs of heterozygousity across the genome were removed.
- Lastly, the final VCF file after all filtering steps was examined in IGV for lingering traces of heterogeneity and/or runs of heterozygousity. Regions that showed evidence of these were removed with bcftools.

### Next Step: [03_context_analysis](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/03_context_analysis)