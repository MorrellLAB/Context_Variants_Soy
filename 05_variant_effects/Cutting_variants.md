# Process Variant Effect Predictor (VeP) output to contain subsets of variants

-Change to the working directory containing VeP output from all variants\
```cd /Users/pmorrell/Dropbox/Documents/Work/Manuscripts/Soybean\ Context\ of\ Mutations/Analysis/VeP```

-Use sed to print only header lines, and variants that impact individual\
    -Also need to capture stop gains and losses, but not stop retained variants\
```sed -n -e '/\#/p' -e '/frameshift_variant/p' -e '/missense_variant/p' -e '/stop_gained/p' -e '/stop_lost/p' FN27_VeP.txt >FN27_VeP_coding.txt```

-Exclude all lines that include variants that could alter the amino acid\
```sed -e '/frameshift_variant/d' -e '/missense_variant/d' -e '/stop_gained/d' -e '/stop_lost/d' FN27_VeP.txt >FN27_VeP_not_coding.txt```

-Use sed to print only header lines, and variants that impact individual\
    -Also need to capture stop gains and losses, but not stop retained variants\
```sed -n -e '/\#/p' -e '/frameshift_variant/p' -e '/missense_variant/p' -e '/stop_gained/p' -e '/stop_lost/p' BL107_VeP_all.txt >BL107_VeP_coding.txt```

```sed -e '/frameshift_variant/d' -e '/missense_variant/d' -e '/stop_gained/d' -e '/stop_lost/d' BL107_VeP_all.txt >BL107_VeP_not_coding.txt```

-Total variants in BL107
```cd /scratch.global/pmorrell/Context_of_Mutations```\
```grep -v '#' BL107_VeP_all.txt | cut -f 2 | uniq | wc -l```\
11156087\
```grep -v '#' BL107_VeP_all.txt | wc -l```\
21676911\
  -The difference in the total number of changes and total number of variants is 21676911 - 11156087 = 10520824
