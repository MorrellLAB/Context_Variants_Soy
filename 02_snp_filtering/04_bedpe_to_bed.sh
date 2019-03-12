grep -v "#" large_sv_calls.bedpe | grep "TYPE=DEL" | awk -F "\t" '{ OFS="\t"; print $1, $2, $6}' > ~/shared/Projects/Context_Of_Mutations/analysis/10x_analysis/large_sv_calls_dels.bed

grep -v "#" large_sv_candidates.bedpe | grep "TYPE=DEL" | awk -F "\t" '{ OFS="\t"; print $1, $2, $6}' > ~/shared/Projects/Context_Of_Mutations/analysis/10x_analysis/large_sv_calls_candidates_dels.bed

grep -v "#" dels.bedpe | awk -F "\t" '{ OFS="\t"; print $1, $2, $6}' > dels.bed

cat dels.bed large_sv_calls_dels.bed > merged_dels.bed

sort -k1,1 -k2,2n merged_dels.bed > merged_dels_sorted.bed 

bedtools merge -i merged_dels_sorted.bed > merged_dels_collapsed.bed

awk '{diff+=$3-$2} END {print diff}' merged_dels_collapsed.bed 
#36935633

#python
#>>> (36935633)/965821250
#0.038242721414547466

# Deletions span roughly 4% of the mappable genome!
