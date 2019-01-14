#!/bin/sh

#PBS -l mem=22gb,nodes=1:ppn=16,walltime=24:00:00
#PBS -m abe
#PBS -M liux1299@umn.edu
#PBS -q lab


#   Script written by Tom Kono available at https://github.com/MorrellLAB/Deleterious_GP/tree/master/Job_Scripts/Seq_Handling


#	Required for Java
module load java
#	Path to the GATK
#GATK=${HOME}/Shared/Software/GATK-3.5/GenomeAnalysisTK.jar

#	Directory where finished BAM files are stored
BAM_DIR=/panfs/roc/scratch/liux1299/WBDC_Inversions_Project/seq_handling_parts_ref/WBDC_100bp/SAM_Processing/Picard/Finished

#	Build the sample list
SAMPLE_LIST=($(find ${BAM_DIR} -name '*finished.bam'))
#	Put them into a format that will be accepted by the GATK command line
GATK_IN=()
for s in "${SAMPLE_LIST[@]}"
do
	GATK_IN+=("-I $s")
done

#	The output targets file
RTC_OUT=/panfs/roc/scratch/liux1299/WBDC_Inversions_Project/seq_handling_parts_ref/WBDC_100bp/WBDC_100bp_realign.intervals

#	The reference sequence
REF=/home/morrellp/liux1299/Shared/References/Reference_Sequences/Barley/Morex/barley_RefSeq_v1.0/barley_pseudomolecules_parts.fa

#	JAVA OPTIONS
#	-Xmx[amount]	:	use [amount] of memory.
#	-jar <file>		:	execute <file>, which is a jar file

#	GATK OPTIONS
#	-T RealignerTargetCreator
#		Create a list of regions to realign
#	-L Regions
#		Operate only in the genomic intervals specified in this regions file
#	-nct <int>
#		Use <int> CPU cores
#		NOTE: This option can make performance WORSE if the system is
#		IO-limited, and not compute-limited.
#	-R <FASTA file>
#		Where the reference sequence is stored
#	-I <BAM file>
#		The BAM file for which to create intervals
#	-known <file>
#		<file> contains known INDELs. VCF or BED format
#	-o <file>
#		Write the intervals to this file
#		NOTE: This file must end in .list, .intervals, or .interval_list

export _JAVA_OPTIONS="-Xmx127g -Djava.io.tmpdir=/panfs/roc/scratch/liux1299/Picard_tmp"
java -jar /home/morrellp/liux1299/Shared/Software/GATK-3.6/GenomeAnalysisTK.jar\
	-T RealignerTargetCreator\
	-nt 1\
	-R ${REF}\
	${GATK_IN[@]}\
	-o ${RTC_OUT}
