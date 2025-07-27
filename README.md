# 16S_Analysis_GrassCarp

16S rRNA-based analysis of gut microbiome in grass carp under macroalgae dietary treatments. Based on publicly available dataset from BioProject [PRJNA1293113](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1293113).

---

## 🧪 Project Overview

This repository provides a complete workflow for:

- Preprocessing 16S rRNA sequencing data (paired-end FASTQ)
- Generating metadata and manifest files
- Performing alpha and beta diversity analyses
- Visualizing taxonomic abundance at genus/family level
- Running PERMANOVA statistical tests for group comparison

---

## 📁 Repository Structure


📦16S_Analysis_GrassCarp
┣ 📂data
┃ ┣ 📄feature-table.tsv
┃ ┣ 📄taxonomy.tsv
┃ ┣ 📄metadata_with_group.tsv
┃ ┗ 📄README.md
┣ 📂outputs
┃ ┣ 📄ShanonDiversity.pdf
┃ ┣ 📄Top10Genera.pdf
┃ ┣ 📄Top10GenusFamilyHeatmap.pdf
┃ ┣ 📄Top10_Family_Barplot.pdf
┃ ┗ 📄permanova_result.csv
┣ 📂scripts
┃ ┣ 📄make_metadata.sh
┃ ┣ 📄make_manifest_qiime2.sh
┃ ┣ 📄alpha_diversity_stats.R
┃ ┣ 📄beta_diversity_stats.R
┃ ┗ 📄abundance_visualization.R
┣ 📄README.md
┗ 📄LICENSE


---

## 📜 Scripts Overview

| Script Name                 | Language | Description                                                   |
|----------------------------|----------|---------------------------------------------------------------|
| `make_metadata.sh`         | Bash     | Generate sample metadata file with group labels               |
| `make_manifest_qiime2.sh`  | Bash     | Generate QIIME2-compatible manifest from paired-end FASTQs    |
| `alpha_diversity_stats.R`  | R        | Calculate Shannon diversity and perform Wilcoxon test         |
| `beta_diversity_stats.R`   | R        | Perform PCoA and PERMANOVA analysis for beta diversity        |
| `abundance_visualization.R`| R        | Plot top abundant taxa using barplots and heatmaps           |

---

## 📂 Input Data (`/data`)

| File Name                | Description                                     |
|--------------------------|-------------------------------------------------|
| `feature-table.tsv`      | ASV count table (exported from QIIME2 `.qza`)   |
| `taxonomy.tsv`           | Taxonomic assignments for ASVs                 |
| `metadata_with_group.tsv`| Metadata with group annotations                |

---

## 📊 Outputs (`/outputs`)

This folder includes all major visualizations and test results:

- **ShanonDiversity.pdf**: Shannon diversity boxplots + Wilcoxon results
- **Top10Genera.pdf**: Barplot of most abundant genera
- **Top10GenusFamilyHeatmap.pdf**: Heatmap of top abundant taxa
- **Top10_Family_Barplot.pdf**: Barplot of family-level abundance
- **permanova_result.csv**: PERMANOVA test summary table

---

## 📦 Citation

If you use this repository or its scripts, please cite it as:


Somayeh Sarirchi (2025). 16S rRNA Gut Microbiome Analysis in Grass Carp. GitHub repository: https://github.com/somayehsarirchi/16S_Analysis_GrassCarp
DOI: [pending - Zenodo]


---

## 📄 License

This project is open-source and distributed under the terms of the [MIT License](LICENSE), allowing reuse with attribution.

