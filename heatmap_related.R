library(ggplot2)
library(reshape2)
library(tidyverse)

# Check if command-line arguments are provided
args <- commandArgs(trailingOnly = TRUE)

# Check if the correct number of arguments is provided
if (length(args) != 2) {
  stop("Usage: Rscript script.R <input_file> <output_file>")
}

# Input and output file paths
input_file <- args[1]
output_file <- args[2]

# Read the data
data <- read_tsv(input_file)

# Clean the data
data$INDV1 <- gsub("outdir/|_output/Aligned.sortedByCoord.out.bam.sort.fixmate.sort", "", data$INDV1)
data$INDV2 <- gsub("outdir/|_output/Aligned.sortedByCoord.out.bam.sort.fixmate.sort", "", data$INDV2)

# Reshape data for ggplot2
relatedness_matrix <- dcast(data, INDV1 ~ INDV2, value.var = "RELATEDNESS_PHI", drop = FALSE)

# Plot heatmap using ggplot2
p <- ggplot(data = melt(relatedness_matrix, id.vars = "INDV1"), aes(x = variable, y = INDV1, fill = value, label = round(value, 2))) +
  geom_tile() +
  geom_text(size = 3) +  # Add text labels
  scale_fill_gradient(low = "blue", high = "red", na.value = "white") +
  labs(title = "Relatedness Heatmap",
       x = "INDV2", y = "INDV1") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Save the plot to the output file
ggsave(output_file, plot = p, width = 10, height = 8, dpi = 300)
