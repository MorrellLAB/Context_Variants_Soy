#!/bin/bash

#PBS -l mem=1gb,nodes=1:ppn=8,walltime=2:00:00
#PBS -m abe
#PBS -M wyant008@umn.edu
#PBS -q lab

#   This is a script to rename files using lists.

set -o pipefail
set -e

OLD=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/renaming/COM_baseline_oldnames.list
NEW=/panfs/roc/groups/9/morrellp/shared/Projects/Context_Of_Mutations/renaming/COM_baseline_newnames.list

paste ${OLD} ${NEW} | while read OLDNAME NEWNAME;
do mv /panfs/roc/scratch/fernanda/baseline/FastQ/${OLDNAME} /panfs/roc/scratch/fernanda/baseline/FastQ/${NEWNAME};
done
