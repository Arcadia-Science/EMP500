library(tidyverse)

# Filter the EMP500 Bioproject metadata TSV to get WGS shotgun metagenome samples, and those that have descriptive scientific names
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

# filter out scientific names that are 'gut metagenome' or just 'metagenome' since don't really know what these are and already have a good chunk to work with
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

# from the EMP500 fetchngs metadata samplesheet, filter samples that are only activated sludge (n=40) to do a test run to estimate run times, resource allocation, cost, etc.
emp500_fetchngs_csv <- read.csv("metadata/EMP500_fetchngs_samplesheet.csv")

as_subset <- emp500_fetchngs_csv %>% 
  filter(scientific_name == "activated sludge metagenome")

as_subset_s3_uris <- as_subset %>% 
  select(sample, fastq_1, fastq_2)

write.csv(as_subset_s3_uris, "metadata/EMP500-AS-s3-uris.csv", quote = FALSE, row.names = FALSE)
