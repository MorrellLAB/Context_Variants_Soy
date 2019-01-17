#!/usr/bin/env python3

"""Usage: python3 high_pi_regions.py [window_size] [vcf_file] [threshold] > file_name.bed
Calculates pi in windows across the soybean genome.
Outputs regions greater than the threshold value."""

import allel
import numpy as np
import sys
exec(open("/panfs/roc/groups/9/morrellp/shared/References/Reference_Sequences/Soybean/PhytozomeV11/Gmax/assembly/soybean_contigs_dict.py").read())

# Process arguments
wsize = sys.argv[1]
vcf_file = sys.argv[2]
threshold = float(sys.argv[3])

# Loop over each contig in the dictionary
for key in chrom_lengths:
    # Import and process the vcf file
    callset = allel.read_vcf(vcf_file, region=key)
    try:
        g = allel.GenotypeArray(callset['calldata/GT'])
    except KeyError:
        continue
    ac = g.count_alleles()
    pos = callset['variants/POS']
    # Calculate pi
    pi, windows, n_bases, counts = allel.stats.windowed_diversity(pos, ac, size=int(wsize), start=1, stop=int(chrom_lengths[key]))
    window_pos = windows[:,0]
    # Add regions to the BED file
    for i in range(pi.size):
        if pi[i] > threshold:
            # The window positions are 1-based, but BED is 0-based, so we subtract 1
            start = str(windows[i,0] - 1)
            stop = str(windows[i,1])
            print(key + "\t" + start + "\t" + stop)
    # if key == "Chr20":
    #     break