# Process Variant Effect Predictor (VeP) output to contain subsets of variants

- Change to the working directory containing VeP output from all variants\
```cd /Users/pmorrell/Dropbox/Documents/Work/Manuscripts/Soybean\ Context\ of\ Mutations/Analysis/VeP```

- Use sed to print only header lines, and variants that impact individual\
```sed -n -e '/\#/p' -e '/frameshift_variant/p' -e '/missense_variant/p' FN27_VeP.txt >FN27_VeP_coding.txt```

- Print all lines that include variants that do not alter the amino acid\
```sed -e '/frameshift_variant/d' -e '/missense_variant/d' FN27_VeP.txt >FN27_VeP_not_coding.txt```
