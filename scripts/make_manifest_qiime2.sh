#!/bin/bash
# Author: Somayeh Sarirchi
# Script: make_manifest_qiime2.sh
# Description: Generate a QIIME2-compatible manifest file for importing paired-end FASTQ files

WORKDIR=$(pwd)
OUTFILE=${WORKDIR}/manifest_qiime2.tsv

echo "sample-id,absolute-filepath,direction" > $OUTFILE

for f in *_1_clean.fastq.gz; do
  sample=$(basename "$f" _1_clean.fastq.gz)
  echo "${sample},${WORKDIR}/${sample}_1_clean.fastq.gz,forward" >> $OUTFILE
  echo "${sample},${WORKDIR}/${sample}_2_clean.fastq.gz,reverse" >> $OUTFILE
done

echo "✔ Manifest file created: $OUTFILE"
