# Earth Microbiome Project 500 Metagenomes
This repository documents analysis code and how community resource files (such as assemblies, taxonomy information, proteins, etc.) were generated from the Earth Microbiome Project (EMP) 500 metagenomes. The analyses and resources were generated from metagenomes seqeunced as part of Shaffer et al. **Standardized multi-omics of Earth's microbiomes reveals microbial and metabolite diversity. (2022). [https://doi.org/10.1038/s41564-022-01266-x](https://www.nature.com/articles/s41564-022-01266-x). Metagenomic reads were accessed from the ENA at Bioproject [PRJEB42019](https://www.ebi.ac.uk/ena/browser/view/PRJEB42019).

## Download EMP500 Metagenomes
From the Biproject [PRJEB42019](https://www.ebi.ac.uk/ena/browser/view/PRJEB42019) page the TSV report was downloaded and used to select a subset of reads to use for this project. Since this Bioproject contains both 16S rRNA amplicon sequencing and shotgun metagenomic sequencing, the script `scripts/emp_metadata_filter.R` was used to select only shotgun metagenomic sequencing samples. Additionally, we filtered out samples with a scientific name of "gut metagenome" or simply just "metagenome" since neither of these were descriptive enough to move forward with. This left a total of ~2200 shotgun metagenomes from diverse biomes.

These metagenomes were downloaded from the ENA using the `nf-core/fetchngs` Nextflow pipeline, which was launched on Tower with:

```
nextflow run 'https://github.com/nf-core/fetchngs
    -name EMP500_download
    -profile docker
    -with-tower
    -r master
    -input_type sra
    -input EMP500_subset_accessions.csv
    -outdir s3://nf-metagenomics/EMP500/raw_data
    -nf_core_pipeline taxprofiler
```

The `nf_core_pipeline` parameter outputs a samplesheet compliant with the `nf-core/taxprofiler` pipeline, which of the options is the closest pipeline that creates a samplesheet that we will need for tracking metadata and inputting into the `Arcadia-Science/metagenomics` workflow. This samplesheet is the `metadata/EMP500_fetchngs_samplesheet.csv` file.

```

## Process EMP500 Metagenomes

## Analyze EMP500 Metagenomes
