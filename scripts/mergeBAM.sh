#!/bin/bash

set -eo pipefail

#   Check for dependencies
# $(command -v bamtools > /dev/null 2> /dev/null) || (echo "Please install BAMtools for this script" >&2; exit 1)
$(command -v java > /dev/null 2> /dev/null) || (echo "Please install Java for this script" >&2; exit 1)
$(command -v parallel > /dev/null 2> /dev/null) || (echo "Please install GNU Parallel for this script" >&2; exit 1)

#   Some useful global variables
OUT_DEFAULT="$(pwd -P)/merged"
PICARD_DEFAULT="/usr/local/bin/picard.jar"
declare -x DELIMITER=','

#   Usage message
function Usage() {
    echo -e "\
Usage: $0 -t|--table <table> -s|--sample-list <sample list> [-o|--outdirectory <outdirectory>] [-p|--picard <picard jar>]\n\
Where:      <table> is the sample name table (see below) \n\
            <sample list> is a list of BAM files, named with the sample names in <table> \n\
            [<outdirectory>] is an optional output directory, defaults to ${OUT_DEFAULT} \n\
            [<picard jar>] is an optional path to the Picard JAR, defaults to ${PICARD_DEFAULT} \n\
\n\
The sample name table is a whitespace-delimited table where the new sample name \n\
    is in the first column and the old sample names are in subsequent columns \n\
    Each row does not need to have the same number of columns as other rows \n\
    Lines starting with a '#' symbol are treated as comments and ignored \n\
\n\
Example: \n\
#This line is ignored
MergedName1    OldName1    OldName2    OldName3
MergedName2    NameOld1    NameOld2    NameOld3    NameOld4
MergedName3    Old1        Old
" >&2
    exit 1
}

#   Check for the required number of arguments
[[ "$#" -lt 4 ]] && Usage

#   Parse the arguments
while [[ "$#" -gt 1 ]]
do
    KEY="$1"
    case "${KEY}" in
        -t|--table)
            TABLE="$2"
            shift
            ;;
        -s|--sample-list) # Sample list
            SAMPLE_LIST="$2"
            shift
            ;;
        -o|--outdirectory)
            OUTDIR="$2"
            shift
            ;;
        -p|--picard)
            PICARD_JAR="$2"
            shift
            ;;
        *)
            Usage
            ;;
    esac
    shift
done

#   Argument checking
[[ -z "${OUTDIR}" ]] && OUTDIR="${OUT_DEFAULT}"
[[ -z "${PICARD_JAR}" ]] && PICARD_JAR="${PICARD_DEFAULT}"
[[ -f "${PICARD_JAR}" ]] || (echo "Cannot find Picard JAR file at ${PICARD_JAR}, please provide path to Picard JAR file" >&2; exit 1)
[[ -f "${SAMPLE_LIST}" ]] || (echo "Cannot find ${SAMPLE_LIST}, exiting..." >&2; exit 1)
[[ -f "${TABLE}" ]] || (echo "Cannot find ${TABLE}, exiting..." >&2; exit 1)

#   Make our output directory
mkdir -p "${OUTDIR}"

#   Read our sample names into an associative array
declare -A SAMPLE_NAMES
while read line
do
    name=$(echo "${line}" | tr '[:space:]' ' ' | cut -f 1 -d ' ')
    [[ "${name:0:1}" == '#' ]] && continue
    SAMPLE_NAMES["${name}"]="$(echo ${line} | tr '[:space:]' ${DELIMITER} | cut -f 2- -d ${DELIMITER})"
done < "${TABLE}"

#   A function to merge the files
function merge() {
    local samplelist="$1" # Where is our sample list?
    local mergedname="$2" # What is the name of our merged sample?
    local outdir="$3" # Where do we put our output file?
    local picardjar="$4" # Where is our Picard JAR file?
    local -a samples=($(echo $5 | tr "${DELIMITER}" ' ')) # Make an array of old sample names
    #   Pick out our BAM files
    local -a bamfiles=($(grep --color=never -f <(echo "${samples[@]}" | tr ' ' '\n') "${samplelist}"))
    #   Create an output name
    local outname=""${outdir}/${mergedname}_merged.bam
    #   Merge the BAM files
    # (set -x; bamtools merge -list <(echo "${bamfiles[@]}" | tr ' ' '\n') > "${outdir}/${mergedname}_merged.bam")
    (set -x; java -jar "${picardjar}" MergeSamFiles $(for s in ${bamfiles[@]}; do echo "I=$s "; done) O="${outname}")
    echo "Merged bam file for sample ${mergedname} can be found at ${outname}" >&2
}

#   Export the function
export -f merge

parallel --verbose --xapply "merge ${SAMPLE_LIST} {1} ${OUTDIR} ${PICARD_JAR} {2}" ::: "${!SAMPLE_NAMES[@]}" ::: "${SAMPLE_NAMES[@]}"
