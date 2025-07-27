
# Author: Somayeh Sarirchi
# Title: Beta Diversity Analysis with PCoA and PERMANOVA
# Description: Perform PCoA using Bray–Curtis distance and test group differences using PERMANOVA

library(vegan)
library(ggplot2)
library(readr)

# Load metadata and PCoA coordinates
metadata <- read_tsv("exported/metadata_with_group.tsv")
pcoa <- read_tsv("exported/beta/coordinates.tsv")
pcoa <- merge(pcoa, metadata, by.x = "#SampleID", by.y = "SampleID")

# Read proportion of variance explained
prop_line <- readLines("exported/beta/ordination.txt")[3]
prop_vals <- as.numeric(unlist(strsplit(prop_line, "\t")))
pc1_var <- round(100 * prop_vals[1], 1)
pc2_var <- round(100 * prop_vals[2], 1)

# Plot PCoA with variance percentages on axes
ggplot(pcoa, aes(x = PC1, y = PC2, color = group, shape = group)) +
  geom_point(size = 4) +
  theme_minimal() +
  labs(
    title = "PCoA (Bray-Curtis)",
    x = paste0("PC1 (", pc1_var, "%)"),
    y = paste0("PC2 (", pc2_var, "%)")
  )

# Load distance matrix
dist_matrix <- as.matrix(read.table("exported/beta/distance-matrix.tsv",
                                    header = TRUE, row.names = 1, sep = "	"))

# Ensure sample order matches metadata
metadata <- metadata[match(rownames(dist_matrix), metadata$SampleID), ]

# Perform PERMANOVA
permanova_result <- adonis2(dist_matrix ~ group, data = metadata)

# Save results to text and CSV
sink("results/permanova_result.txt")
print(permanova_result)
sink()

write.csv(as.data.frame(permanova_result), "results/permanova_result.csv", row.names = TRUE)
