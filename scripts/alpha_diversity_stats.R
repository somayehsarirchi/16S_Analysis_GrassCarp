# Author: Somayeh Sarirchi
# Title: Alpha Diversity & Wilcoxon Test
# Description: Compute alpha diversity metrics (Shannon, Simpson, Observed) and perform Wilcoxon test between diet and control groups


# Install and load required packages
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install("phyloseq", ask = FALSE)

library(phyloseq)
library(tidyverse)
library(ggplot2)

# Set file paths
base_dir <- "exported"
otu_file <- file.path(base_dir, "table/feature-table.tsv")
tax_file <- file.path(base_dir, "taxonomy/taxonomy.tsv")
metadata_file <- file.path(base_dir, "metadata_with_group.tsv")

# Load OTU table
otu_data <- read.table(otu_file, header = TRUE, sep = "	", skip = 1, row.names = 1, comment.char = "")
otu_mat <- as.matrix(otu_data)
OTU <- otu_table(otu_mat, taxa_are_rows = TRUE)

# Load taxonomy
tax_data <- read.table(tax_file, header = TRUE, sep = "	", row.names = 1, quote = "", comment.char = "")
tax_split <- strsplit(as.character(tax_data$Taxon), ";\s*")
max_rank <- max(sapply(tax_split, length))
tax_mat <- do.call(rbind, lapply(tax_split, function(x) { length(x) <- max_rank; return(x) }))
rownames(tax_mat) <- rownames(tax_data)
colnames(tax_mat) <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")[1:max_rank]
TAX <- tax_table(tax_mat)

# Create phyloseq object
physeq <- phyloseq(OTU, TAX)
metadata <- as.data.frame(read_tsv(metadata_file))
rownames(metadata) <- metadata$SampleID
metadata <- metadata[sample_names(physeq), ]
sample_data(physeq) <- sample_data(metadata)

# Estimate alpha diversity and merge with metadata
alpha_df <- estimate_richness(physeq, measures = c("Shannon", "Simpson", "Observed"))
alpha_df$SampleID <- rownames(alpha_df)
alpha_df <- left_join(alpha_df, metadata, by = "SampleID")

# Convert to long format for plotting
alpha_long <- pivot_longer(alpha_df, cols = c("Shannon", "Simpson", "Observed"),
                           names_to = "Metric", values_to = "Value")

# Boxplot + jitter
p <- ggplot(alpha_long, aes(x = group, y = Value, fill = group)) +
  geom_boxplot(alpha = 0.5, outlier.shape = NA) +
  geom_jitter(aes(color = group), width = 0.15, size = 2) +
  facet_wrap(~ Metric, scales = "free_y") +
  theme_minimal() +
  labs(title = "Alpha Diversity Comparison by Group",
       x = "Group", y = "Diversity Index")

# Save plot
ggsave("results/alpha_diversity_grouped_boxplot_phyloseq.pdf", p, width = 10, height = 6)

# Wilcoxon tests
sink("results/alpha_diversity_wilcoxon_results.txt")
metrics <- c("Shannon", "Simpson", "Observed")
for (metric in metrics) {
  cat("▶", metric, "
")
  sub_data <- alpha_df %>% select(group, all_of(metric)) %>% filter(!is.na(.data[[metric]]))
  test <- wilcox.test(as.formula(paste(metric, "~ group")), data = sub_data, exact = FALSE)
  print(test)
  cat("
")
}
sink()
