# Sample renaming scripts
This directory contains the scripts used to rename the raw FASTQ files. 

### Inputs
- 212 soybean FASTQ files found at `/panfs/roc/scratch/fernanda/baseline/FastQ`

### Files
- `rename_from_lists.sh`: This is the bash script that was used to rename all the files. This script requires two lists, shown below.
- `COM_baseline_oldnames.list`: This is the list of orginal file names, one per line.
- `COM_baseline_newnames.list`: This is the list of new file names, one per line and in the same order as `COM_baseline_oldnames.list`.

### Next Step: [01_sequence_handling](https://github.com/MorrellLAB/Context_Variants_Soy/tree/master/01_sequence_handling)