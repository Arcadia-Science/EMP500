library(tidyverse)

emp_metadata <- read.table("metadata/EMP500_ENA_metadata.txt", sep = "\t", header = TRUE)
colnames(emp_metadata)

emp_subset_groups <- emp_metadata %>% 
  filter(library_strategy == 'WGS') %>% 
  select(scientific_name) %>% 
  group_by(scientific_name) %>% 
  count() %>% 
  arrange(desc(n)) %>% 
  filter(scientific_name != 'gut metagenome') %>% 
  filter(scientific_name != 'metagenome')

sum(emp_subset_groups$n)

emp_metadata %>% 
  filter(library_strategy == "WGS") %>% 
  filter(scientific_name != 'gut metagenome') %>% 
  filter(scientific_name != 'metagenome') %>% 
  select(run_accession, tax_id, scientific_name, base_count) %>% 
  filter(scientific_name == 'activated sludge metagenome')

emp_groups <- emp_metadata %>% 
  filter(library_strategy == 'WGS') %>% 
  select(scientific_name) %>% 
  group_by(scientific_name) %>% 
  filter(scientific_name != 'gut metagenome') %>% 
  filter(scientific_name != 'metagenome') %>% 
  select(scientific_name) %>% 
  unique() %>% 
  pull(scientific_name)

subset_emp_metadata <- emp_metadata %>% 
  filter(library_strategy == 'WGS') %>% 
  filter(scientific_name %in% emp_groups) %>% 
  select(experiment_accession, tax_id, scientific_name)

subset_emp_accessions <- emp_metadata %>% 
  filter(library_strategy == 'WGS') %>% 
  filter(scientific_name %in% emp_groups) %>% 
  select(experiment_accession)

write.csv(subset_emp_accessions, "metadata/EMP500_subset_accessions.csv", row.names = FALSE, quote = FALSE)
