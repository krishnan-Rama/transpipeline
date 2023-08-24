# transpipeline
A slurm pipeline that transforms your transcriptome data into actionable insights in a seamless flow!

## Master Pipeline Overview

This master pipeline serves as a comprehensive workflow for transcriptome processing, from the initial transfer of raw data to the extraction of annotations from UniProt. The script is organized into multiple steps, each encompassing a specific procedure in the pipeline. These procedures include data quality checks, trimming, taxonomic classification, assembly, annotation, and evaluation.

### Significance of the Pipeline

- **Comprehensiveness**: This pipeline offers an end-to-end solution for researchers working with transcriptome data, ensuring that each stage of processing and analysis is addressed.
  
- **Flexibility**: Each step of the pipeline is modular, meaning researchers can easily adapt the pipeline to suit specific requirements or integrate new tools.

- **Scalability**: The use of `sbatch` commands indicates that this script is designed to run on a high-performance computing environment, enabling the processing of large datasets in a parallel manner.

### Configuration through `config.parameters_all`

To maintain the flexibility and adaptability of the pipeline, the master script sources a separate configuration script named `config.parameters_all`. This script presumably contains all the variables and parameters used throughout the pipeline. By managing these variables in a centralized location, users can easily modify the behavior of the pipeline without diving into the intricacies of the master script.

### Linking to Bash Scripts in Every Step

Each step in the master pipeline script invokes an external bash script (found in `${moduledir}`) via the `sbatch` command. This design choice encapsulates the complexity of individual procedures, offering several benefits:

- **Modularity**: The separation of tasks into individual scripts allows for easy replacement, modification, or troubleshooting of specific steps.

- **Parallelization**: With the `--array` flag in some `sbatch` commands, certain steps can process multiple samples simultaneously, optimizing computational time.

- **Logging**: The error and output logs for each step are captured separately, simplifying the debugging process.

## Steps of the Master Pipeline

1. **Data Transfer**: Raw data files are copied from the source directory to a designated raw directory.

2. **FastQC on Raw Data**: Quality control checks are performed on the raw data to assess its initial quality.

3. **Fastp Trimming**: Adapters and low-quality bases are trimmed from the raw data.

4. **FastQC on Trimmed Data**: Quality control checks post-trimming ensure data integrity.

5. **Kraken2 Classification**: The trimmed data undergoes taxonomic classification using Kraken2.

6. **Assembly**: Transcriptome assembly is executed using Trinity.

7. **Evigene Annotation**: The assembled transcriptome is annotated using the evigene tool.

8. **BUSCO Analysis**: Completeness of the assembled transcriptome is assessed using BUSCO.

9. **Trinity Mapping**: Transcriptome data is further processed using Trinity tools for mapping.

10. **Summary Stats and Differential Expression**: Post-processing analysis of the mapped data.

11. **MultiQC Report**: A comprehensive report is generated to summarize results from the previous steps.

12. **Blastdb Configuration**: Blast databases are downloaded and configured.

13. **Multispecies Blast**: A blastp search is performed against a multispecies database.

14. **Annotation Extraction from UniProt**: Annotations are extracted based on blast search results from UniProt.

### Concluding Note

To successfully run this pipeline, ensure that all external bash scripts are present in the specified `${moduledir}` directory and that `config.parameters_all` is properly configured. Always refer to individual bash scripts and the configuration file for more detailed information or to modify specific behaviors of the pipeline.
