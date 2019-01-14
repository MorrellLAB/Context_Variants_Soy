#!/usr/bin/env python3

# Usage: python3 vcf_counts.py <vcf_file> > output.tsv

import allel
import numpy as np
import sys

vcf_file = sys.argv[1]

# Import the data into allel
callset = allel.read_vcf(vcf_file)
gt = allel.GenotypeArray(callset['calldata/GT'])

# Print a header line for the output file
print('Sample\tMissing\tHet\tHom_Alt\tTot_Alt')

# Get the number of samples
index = gt.n_samples
samps = callset['samples']

# Loop over each sample
for i in range(0, index):
	toprint = []
	toprint.append(samps[i])
	toprint.append(gt[:,i].count_missing())
	toprint.append(gt[:,i].count_het())
	toprint.append(gt[:,i].count_hom_alt())
	toprint.append(toprint[2] + toprint[3])
	print(str(toprint[0]) + '\t' + str(toprint[1]) + '\t' + str(toprint[2]) + '\t' + str(toprint[3]) + '\t' + str(toprint[4]))
