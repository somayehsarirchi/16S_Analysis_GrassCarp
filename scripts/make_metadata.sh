#!/bin/bash
# Author: Somayeh Sarirchi
# Script: make_metadata.sh
# Description: Generate a metadata file with sample group annotations (Diet vs. Control)

OUTFILE="metadata_with_group.tsv"

# Header
echo -e "#SampleID	group" > $OUTFILE

# Diet group samples
for sample in SRR34584690 SRR34584691 SRR34584692 SRR34584693 SRR34584694 SRR34584695 SRR34584696 SRR34584698 SRR34584699; do
  echo -e "${sample}	Diet" >> $OUTFILE
done

# Control group samples
for sample in SRR34584700 SRR34584701 SRR34584697; do
  echo -e "${sample}	Control" >> $OUTFILE
done

echo "✅ Metadata file created: $OUTFILE"
