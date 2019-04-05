# sequence_handling Configs and Output
Configuration files and output statistics from the [sequence_handling](https://github.com/MorrellLAB/sequence_handling) pipeline.

### Inputs
- The 106 soybean lines used as a "baseline" for natural variation.
    - `/panfs/roc/scratch/fernanda/baseline/FastQ` 
    - [PRJNA289660](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA289660) ([Valliyodan et al. 2016](https://www.nature.com/articles/srep23598))
- The 30 fast neutron irradiated lines and 1 genetic background line (M92-220)
    - `/panfs/roc/scratch/fernanda/FN30cat`
    - [PRJNA237333](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA237333) 
- Total: 137 FASTQ files

### Dependencies
- [sequence_handling](https://github.com/MorrellLAB/sequence_handling) and all of its [dependencies](https://github.com/MorrellLab/sequence_handling/wiki/Dependencies)
- bcftools/1.6

### Files

The FASTQ files were processed in two batches: the baseline 106 (called BL107) and the fast neutron 30 + 1 genetic background (called FN30 or FN30cat). Each batch had a separate Config file for sequence_handling, noted below, but the processing steps were the same for each. `sample_list_lines.sh` was used to make the sample lists listed in the Config files.

- FN30 Config: `ConfigCAT`
- BL107 Config: `baseline_config`

The following handlers were run on each batch separately in this order:

1. Quality_Assessment: The quality statistics summary from each batch is located [here](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling/Quality_Assessment).
2. Adapter_Trimming
3. Read_Mapping
4. SAM_Processing: The mapping statistics summary from each batch is located [here](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling/SAM_Processing).
5. Coverage_Mapping: The coverage statistics summary from each batch is located [here](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling/Coverage_Mapping).
6. Haplotype_Caller

After obtaining GVCF files for all 137 samples, the batches were combined for further analysis. The following handlers were run on all 137 samples together, using the `ConfigCAT` config file:

7. Genotype_GVCFs
8. Create_HC_Subset
9. Variant_Recalibrator

The VCF file output from Variant_Recalibrator was split into two batches using bcftools. The first batch (called BL107) included the 106 baseline samples + 1 genetic background line. The second batch (called FN30 or FN30cat) included the 30 fast neutron irradiated samples. The following handlers were run on both batches separately:

10. Variant_Analysis (denoted preF)
11. Variant_Filtering
12. Variant_Analysis (denoted postF)

Plots and variant quality statistics from Variant_Analysis for each batch can be found [here](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling/Variant_Analysis). Each batch used different filtering parameters for Variant_Filtering, noted below:

- FN30 Variant_Filtering used the parameters noted in `FN30_Variant_Filtering`
- BL107 Variant_Filtering used the parameters noted in `ConfigCAT`

The VCF file output of Variant_Filtering for each batch was used in further analysis steps.

### Next Step: [02_snp_filtering](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/02_snp_filtering)