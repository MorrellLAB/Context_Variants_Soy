# Sample renaming scripts
This directory contains scripts used to rename raw FASTQ files. 

### Inputs
- 212 soybean FASTQ files found at `/panfs/roc/scratch/fernanda/baseline/FastQ`

### Files
- `fastq-dumpq_script_106_samples`: This script was used to download the 106 samples from the SRA.
- `rename_from_lists.sh`: This bash script was used to rename the files. This script requires two lists, shown below.
- `COM_baseline_oldnames.list`: This is the list of orginal file names, one per line.
- `COM_baseline_newnames.list`: This is the list of new file names, one per line and in the same order as `COM_baseline_oldnames.list`.

### Next Step: [01_sequence_handling](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling)