
# Author: Somayeh Sarirchi
# Title: Abundance Visualization
# Description: Visualize the relative abundance of top genera, families, and Genus(Family) combinations using barplots and heatmaps

library(ggplot2)
library(dplyr)
library(reshape2)
library(pheatmap)

# Set project directory
project_dir <- "exported"

# Load metadata
metadata_path <- file.path(project_dir, "metadata_with_group.tsv")
metadata <- read.table(metadata_path, sep = "\t", header = TRUE, row.names = 1, check.names = FALSE)
metadata$SampleID <- rownames(metadata)

# Load feature table
table_path <- file.path(project_dir, "table", "feature-table.tsv")
feature_table <- read.table(table_path, sep = "\t", header = TRUE, row.names = 1, skip = 1, check.names = FALSE)
feature_table <- feature_table[, -1]  # Remove unnecessary first column

# Load taxonomy
tax_path <- file.path(project_dir, "taxonomy", "taxonomy.tsv")
taxonomy <- read.table(tax_path, sep = "\t", header = TRUE, row.names = 1, quote = "", comment.char = "")

# ---- Genus Barplot ----
taxonomy$Genus <- sapply(strsplit(as.character(taxonomy$Taxon), "; "), function(x) tail(x, 1))
common_features <- intersect(rownames(feature_table), rownames(taxonomy))
feature_table_genus <- feature_table[common_features, ]
taxonomy_genus <- taxonomy[common_features, ]
feature_table_genus$Genus <- taxonomy_genus$Genus

genus_table <- feature_table_genus %>%
  group_by(Genus) %>%
  summarise(across(where(is.numeric), sum), .groups = "drop")

genus_matrix <- as.data.frame(genus_table)
rownames(genus_matrix) <- genus_matrix$Genus
genus_matrix$Genus <- NULL

rel_abund_genus <- apply(genus_matrix, 2, function(x) x / sum(x))
rel_abund_genus_df <- melt(rel_abund_genus)
colnames(rel_abund_genus_df) <- c("Genus", "SampleID", "Abundance")
rel_abund_genus_df <- merge(rel_abund_genus_df, metadata, by = "SampleID")

# Top 10 genera
top_genera <- names(sort(tapply(rel_abund_genus_df$Abundance, rel_abund_genus_df$Genus, mean), decreasing = TRUE))[1:10]
rel_abund_top <- rel_abund_genus_df[rel_abund_genus_df$Genus %in% top_genera, ]

ggplot(rel_abund_top, aes(x = SampleID, y = Abundance, fill = Genus)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ group, scales = "free_x") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Top 10 Genera", y = "Relative Abundance", x = "Sample")

# ---- Family Barplot ----
taxonomy$Family <- sapply(strsplit(as.character(taxonomy$Taxon), "; "), function(x) grep("f__", x, value = TRUE)[1])
feature_table_family <- feature_table
feature_table_family$Family <- taxonomy[rownames(feature_table_family), "Family"]

family_table <- feature_table_family %>%
  group_by(Family) %>%
  summarise(across(where(is.numeric), sum), .groups = "drop")

family_matrix <- as.data.frame(family_table)
rownames(family_matrix) <- family_matrix$Family
family_matrix$Family <- NULL

rel_abund_family <- apply(family_matrix, 2, function(x) x / sum(x))
rel_abund_family_df <- melt(rel_abund_family)
colnames(rel_abund_family_df) <- c("Family", "SampleID", "Abundance")
rel_abund_family_df <- merge(rel_abund_family_df, metadata, by = "SampleID")

top_families <- names(sort(tapply(rel_abund_family_df$Abundance, rel_abund_family_df$Family, mean), decreasing = TRUE))[1:10]
rel_abund_family_top <- rel_abund_family_df[rel_abund_family_df$Family %in% top_families, ]

ggplot(rel_abund_family_top, aes(x = SampleID, y = Abundance, fill = Family)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ group, scales = "free_x") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Top 10 Families", y = "Relative Abundance", x = "Sample")

# ---- Genus(Family) Heatmap ----
taxonomy$Genus_Family <- paste(taxonomy$Genus, "(", taxonomy$Family, ")", sep = "")
feature_table_genfam <- feature_table[common_features, ]
feature_table_genfam$Genus_Family <- taxonomy[rownames(feature_table_genfam), "Genus_Family"]

genfam_table <- feature_table_genfam %>%
  group_by(Genus_Family) %>%
  summarise(across(where(is.numeric), sum), .groups = "drop")

genfam_matrix <- as.data.frame(genfam_table)
rownames(genfam_matrix) <- genfam_matrix$Genus_Family
genfam_matrix$Genus_Family <- NULL

valid_genfam <- !grepl("Unassigned|uncultured|NA", rownames(genfam_matrix), ignore.case = TRUE)
genfam_matrix_filtered <- genfam_matrix[valid_genfam, ]

top10_genfam <- names(sort(rowMeans(genfam_matrix_filtered), decreasing = TRUE))[1:10]
otu_top_filtered <- genfam_matrix_filtered[top10_genfam, ]

pheatmap(otu_top_filtered,
         scale = "row",
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         fontsize_row = 9,
         fontsize_col = 10,
         main = "Top 10 Genus (Family) Heatmap")
