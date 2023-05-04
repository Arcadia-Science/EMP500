library(sourmashconsumr)
library(tidyverse)

#########################################################
# Sourmash results of EMP AS reads
#########################################################

## read in all files for reads

# reads signatures
reads_sigs_directory <- ("data/sourmash/sketch/reads")
reads_sigs_files <- list.files(path = reads_sigs_directory, pattern = "*.reads.sig",  full.names = TRUE)
reads_sigs <- read_signature(reads_sigs_files)

# reads compare
reads_compare_csv <- read_compare_csv("data/sourmash/compare/reads.comp.csv", sample_to_rownames = F)

# reads gather CSVs
reads_gather_directory <- ("data/sourmash/gather/reads/")
reads_gather_csvs <- list.files(path = reads_gather_directory, pattern = "*.reads.gather.csv", full.names = TRUE)
reads_gather <- read_gather(reads_gather_csvs, intersect_bp_threshold = 50000)

# reads taxonomy annotate
reads_taxonomy_directory <- ("data/sourmash/taxonomy/reads/")
reads_taxonomy_csvs <- list.files(path = reads_taxonomy_directory, pattern = "*.reads.gather.with-lineages.csv.gz", full.names = TRUE)
reads_taxonomy <- read_taxonomy_annotate(reads_taxonomy_csvs, intersect_bp_threshold = 50000, separate_lineage = T)

# plot compare mds and heatmap
reads_comp_mds <- make_compare_mds(reads_compare_csv)
plot_compare_mds(reads_comp_mds)
plot_compare_heatmap(reads_comp_mds, cexRow = 0.75, cexCol = 0.75)

# plotting gather results
plot_gather_classified(reads_gather)

# plotting taxonomy annotate results
glom_taxonomy_reads <- tax_glom_taxonomy_annotate(reads_taxonomy, tax_glom_level = "genus", glom_var = "f_unique_to_query")
glom_taxonomy_reads_upset <- from_taxonomy_annotate_to_upset_inputs(reads_taxonomy, tax_glom_level = "order")
plot_taxonomy_annotate_upset(glom_taxonomy_reads_upset, fill = "phylum")
plot_taxonomy_annotate_sankey(reads_taxonomy, tax_glom_level = "order")


#########################################################
# Sourmash results of EMP AS assemblies
#########################################################

## read in all files for assemblies

# reads signatures
assemblies_sigs_directory <- ("data/sourmash/sketch/assemblies")
assemblies_sigs_files <- list.files(path = assemblies_sigs_directory, pattern = "*.assembly.sig",  full.names = TRUE)
assemblies_sigs <- read_signature(assemblies_sigs_files)

# reads compare
assemblies_compare_csv <- read_compare_csv("data/sourmash/compare/assembly.comp.csv", sample_to_rownames = F)

# reads gather CSVs
assemblies_gather_directory <- ("data/sourmash/gather/assemblies/")
assemblies_gather_csvs <- list.files(path = assemblies_gather_directory, pattern = "*.assembly.gather.csv", full.names = TRUE)
assemblies_gather <- read_gather(assemblies_gather_csvs, intersect_bp_threshold = 50000)

# reads taxonomy annotate
assemblies_taxonomy_directory <- ("data/sourmash/taxonomy/assemblies/")
assemblies_taxonomy_csvs <- list.files(path = assemblies_taxonomy_directory, pattern = "*.assembly.gather.with-lineages.csv.gz", full.names = TRUE)
assemblies_taxonomy <- read_taxonomy_annotate(assemblies_taxonomy_csvs, intersect_bp_threshold = 50000, separate_lineage = T)

# plotting gather results
plot_gather_classified(assemblies_gather)

# plotting taxonomy annotate results
glom_taxonomy_assemblies <- tax_glom_taxonomy_annotate(assemblies_taxonomy, tax_glom_level = "genus", glom_var = "f_unique_to_query")
glom_taxonomy_assemblies_upset <- from_taxonomy_annotate_to_upset_inputs(assemblies_taxonomy, tax_glom_level = "order")
plot_taxonomy_annotate_upset(glom_taxonomy_assemblies_upset, fill = "phylum")
plot_taxonomy_annotate_sankey(assemblies_taxonomy, tax_glom_level = "order")

plot_taxonomy_annotate_sankey(assemblies_taxonomy, tax_glom_level = "genus")

# investigating "strains" of Accumulibacter
taxonomy_filtered <- assemblies_taxonomy %>% 
  filter(!species %in% c("unidentified", "unidentified virus", "unidentified plasmid")) 

acc_strains_test <- taxonomy_filtered %>% 
  filter(genus == 'Candidatus Accumulibacter') %>% 
  filter(query_name == 'ERX4811162.assembly' | query_name == 'ERX4811163.assembly') %>% 
  from_taxonomy_annotate_to_multi_strains()

acc_strains_test$plt

all_acc_strains <- taxonomy_filtered %>% 
  filter(genus == 'Candidatus Accumulibacter') %>% 
  from_taxonomy_annotate_to_multi_strains()

acc_strains_plot <- all_acc_strains$plt

ggsave("figs/all_acc_strains.png", acc_strains_plot, width=50, height=50, units=c("cm"))
