#!/usr/bin/env python3

"""Usage: python3 calculate_windowed_pi.py <window_size> <vcf_file> <output name>
Calculates pi in windows across the soybean genome."""

import allel
import numpy as np
import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
exec(open("/panfs/roc/groups/9/morrellp/shared/References/Reference_Sequences/Soybean/PhytozomeV11/Gmax/assembly/soybean_contigs_dict.py").read())

# Process arguments
wsize = sys.argv[1]
vcf_file = sys.argv[2]
out_name = sys.argv[3]

# Initialize variables
wg_pi = []
wg_pos = []
offset = 0

# Define the function for plotting
def plot_pi(window_pos, pi, chrom):
    fig = plt.figure(figsize=(9, 3))
    plt.plot(window_pos, pi)
    if chrom == "genomic":
        chrom_breaks = [56831624, 105409129, 151188910, 203578056, 245812554, 297229040, 341859686, 389697626, 439887390, 491454288, 526221155, 566312469, 612186631, 661228823, 712985166, 750872180, 792513546, 850532288, 901279204, 949183385]
        for xc in chrom_breaks:
            plt.axvline(x=xc, color='0.50', linewidth=0.25)
        plt.xlabel('Cumulative Genomic Position')
    else:
        plt.xlabel(key + ' Position')
    plt.title(out_name + "_" + chrom)
    plt.ylabel('Pi')
    plt.ylim(bottom=0)
    #plt.ylim(top=0.0001)
    plt.xlim(left=0)
    plt.tight_layout()
    plt.savefig(out_name + "_" + chrom + ".pdf")
    plt.close(fig)

# Loop over each contig in the dictionary
for key in chrom_lengths:
    # Import and process the vcf file
    print("Processing " + key)
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
    # Plot pi for this chromosome
    plot_pi(window_pos, pi, key)
    # Add this chromosome's data to the whole genome set
    wg_pi.extend(pi)
    offset_pos = [x+offset for x in window_pos]
    wg_pos.extend(offset_pos)
    offset += int(chrom_lengths[key])

# Plot the whole-genome figure
plot_pi(wg_pos, wg_pi, "genomic")