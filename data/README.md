# Input Data Description

This analysis uses publicly available 16S rRNA sequencing data from the NCBI SRA:

- **BioProject**: [PRJNA1293113](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1293113)
- **Fish Species**: Grass Carp (_Ctenopharyngodon idella_)
- **Sample Groups**: Diet-treated vs. Control
- **Accession IDs**:  
  - **Diet**:  SRR34584690 – SRR34584696, SRR34584698- SRR34584699   
  - **Control**: SRR34584697, SRR34584700 – SRR34584701 

Raw FASTQ files were downloaded using the `prefetch` and `fasterq-dump` tools from the SRA Toolkit.

---

### 🔢 Files in This Folder

| File Name | Description |
|-----------|-------------|
| `feature-table.tsv` | OTU count table (exported from QIIME2 `.qza` file) |
| `taxonomy.tsv` | Taxonomic assignments for ASVs (from `classify-sklearn`) |
| `metadata_with_group.tsv` | Metadata with group annotations for diversity and statistical analysis |

These files were generated during QIIME2 and downstream analysis, and are essential for running the R scripts in the `scripts/` folder.

