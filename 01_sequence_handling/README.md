# sequence_handling Configs and Output
Configuration files and output statistics from the [sequence_handling](https://github.com/MorrellLAB/sequence_handling) pipeline.

### Inputs
- The 106 soybean lines used as a "baseline" for natural variation.
    - `/panfs/roc/scratch/fernanda/baseline/FastQ` 
    - [PRJNA289660](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA289660) ([Valliyodan et al. 2016](https://www.nature.com/articles/srep23598))
- The 30 fast neutron irradiated lines and 1 genetic background line (M92-220)
    - `/panfs/roc/scratch/fernanda/FN30cat`
    - [PRJNA237333](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA237333) ([Bolon et al. 2014](https://doi.org/10.1534/genetics.114.170340))
- M92-220 S17, S79, and S84 150bp PE Illumina resequencing (sequenced as part of the USDA BRAG project)
- M92-220 S84 sequenced with 10x Genomics linked reads and processed with Long Ranger

### Dependencies
- [sequence_handling 2.1.0](https://github.com/MorrellLAB/sequence_handling/releases/tag/v2.1.0) and all of its [dependencies](https://github.com/MorrellLab/sequence_handling/wiki/Dependencies)
- bcftools/1.9

### Processing Steps

M920-220 S17 and S84 were combined using `zcat`, since they were the same sample and the same library prep.  

The FASTQ files were processed in three batches. Each batch had a separate Config file for sequence_handling, noted below, but the processing steps were the same for each. `sample_list_lines.sh` was used to make some of the sample lists used in the Config files.  

- FN30 Config (`ConfigCAT`): The 30 fast neutron sample + one genetic background sample.
- BL107 Config (`baseline_config`): The 106 baseline samples.
- M92-220 Config (`m92-220_config`): The two Illumina sequencing runs of M92-220 (S84+S17 and S79). Starting with Coverage_Mapping, the genetic background sample from the FN30 (above) and the 10x Genomics sample S84 were added. Create_HC_Subset and Variant_Recalibrator were not run on these samples.

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
10. Variant_Analysis: Plots and variant quality statistics for each batch can be found [here](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling/Variant_Analysis). 

The VCF file output from Variant_Recalibrator was split into two batches using bcftools. The first batch (called BL107) included the 106 baseline samples + 1 genetic background line. The second batch (called FN30 or FN30cat) included the 30 fast neutron irradiated samples. Variant_Analysis was run on both batches separately. 

The VCF file output of Variant_Recalibrator for each batch (FN30 and BL107) was used in further analysis steps. For the M92-220 batch, the combined output from Genotype_GVCFs was used. Variant filtering was performed using custom scripts (next step), not with sequence_handling's Variant_Filtering handler.

### Next Step: [02_snp_filtering](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/02_snp_filtering)