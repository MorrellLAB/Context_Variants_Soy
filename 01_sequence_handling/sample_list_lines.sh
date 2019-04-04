# (script to create file list from Paul Hoffman)  02/07/2017

#!/bin/bash

set -eo pipefail

OUT_DEFAULT="$(pwd -P)/out"
# NUMBER='^[0-9]+$'

function Usage() {
    echo -e "\
Usage: $0 -e|--extension <extension> -l|--lines <lines> [-d|--directory] <directory> [-p|--prefix] <prefix> \n\
Where:      <extension> is the extension of the files we're looking for \n\
            <lines> is the number of lines per sample file \n\
            <directory> is an optional directory to look in, defaults to $(pwd -P) \n\
            <prefix> is optional output prefix, defaults to ${OUT_DEFAULT} \n\
    " >&2
    exit 1
}

if [[ "$#" -lt 4 ]]; then Usage >&2; exit 1; fi

while [[ "$#" -gt 1 ]]
do
    key="$1"
    case "${key}" in
        -e|--extension)
            EXTENSION="$2"
            shift
            ;;
        -l|--lines)
            LINES="$2"
            shift
            ;;
        -d|--directory)
            DIRECTORY="$2"
            shift
            ;;
        -p|--prefix)
            OUTPUT="$2"
            shift
            ;;
        *)
            Usage
            ;;
    esac
    shift
done

if [[ -z "${EXTENSION}" ]] || [[ -z "${LINES}" ]]; then Usage; fi # Make sure we have $EXTENSION and $LINES
# if ! [[ "${LINES}" =~ "${NUMBER}" ]]; then echo "<lines> must be an integer, not ${LINES}" >&2; exit 1; fi # Make sure $LINES is a number
if [[ -z "${OUTPUT}" ]]; then OUTPUT="${OUT_DEFAULT}"; fi # Set default for $OUTPUT
if [[ -z "${DIRECTORY}" ]]; then DIRECTORY="$(pwd -P)"; fi # Set default for $DIRECTORY

if [[ "${EXTENSION:0:1}" != '.' ]]; then EXTENSION=".${EXTENSION}"; fi # Add a period to $EXTENSION is not already there

declare -a SAMPLES=($(find "${DIRECTORY}" -maxdepth 1 -name "*${EXTENSION}" | sort)) # Find our samples
(set -x; split -d -l "${LINES}" <(echo "${SAMPLES[@]}" | tr ' ' '\n') "${OUTPUT}") # Write our lists

echo "Made $(ls -1 ${OUTPUT}* | wc -l ) sample lists from ${#SAMPLES[@]} samples" >&2
