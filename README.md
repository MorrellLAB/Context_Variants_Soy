# Fast neutron mutagenesis in soybean creates frameshift mutations 
Wyant SR, Rodriguez MF, Carter CK, Parrott WA, Jackson SA, Stupar RM, Morrell PL (2020). Fast neutron mutagenesis in soybean creates frameshift mutations. [bioRxiv]()

## Description
The mutagenic effects of ionizing radiation have been used for decades to create novel variants in experimental populations. Fast neutron (FN) bombardment as a mutagen has been especially widespread in plants, but the full spectrum of induced mutations is poorly understood. We contrast small insertions and deletions (indels) observed in 27 soybean lines subject to FN irradiation with the standing indels identified in 107 diverse soybean lines. We use the same populations to contrast the nature and context (bases flanking a nucleotide change) of single nucleotide variants. 

## Datasets
- Illumina paired-end sequencing for the line M92-220: [SRA BIOSAMPLE NUMBER]()
- 10X Genomics linked read sequencing for the line M92-220: [SRA BIOSAMPLE NUMBER]()
- Illumina paired-end sequencing from 30 fast-neutron treated lines and one M92-220 plant from Bolon et al. 2014
    - [Publication](https://doi.org/10.1534/genetics.114.170340) 
    - [SRA PRJNA237333](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA237333)
- Illumina paired-end sequencing from 106 diverse soybean landraces and cultivated varieties from Valliyodan et al. 2016 
    - [Publication](https://doi.org/10.1038/srep23598) 
    - [SRA SRP062245](https://www.ncbi.nlm.nih.gov//bioproject/PRJNA289660)

## Repository Organization
### 00_renaming
The directory contains scripts and lists used to rename raw FASTQ files before processing.

### 01_sequence_handling
This directory contains scripts and configuration files used to process raw FASTQ files into VCF files. Quality assessment statistics, such as mapping statistics and coverage summaries, are also included here.

### 02_snp_filtering
This directory contains scripts used to subtract the genetic background from the set of variants detected in the treatment lines and perform quality filtering. 

### 03_context_analysis
This directory contains configuration files and scripts used to analyze the context of new mutations. 

### 04_figures
This directory contains scripts that reproduce manuscript figures.

### 05_variant_effects
This directory includes scripts and configurations to run VEP (Variant Effect Predictor). The reports for each class of variant are also included.
