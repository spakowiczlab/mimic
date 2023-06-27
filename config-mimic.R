library(dplyr)

#------------------------
# Common
#------------------------
scratch_dir="/fs/scratch/PAS1695/projects/mimic"
group_dir="/fs/ess/PAS1695/projects/mimic"
data_dir=file.path(group_dir, "rawdata")
subsample_dir=file.path(group_dir, "subset_data")
ref_dir=file.path(group_dir, "references")
results_dir <- file.path(group_dir, "results")

username=Sys.info()[["user"]]
out_dir=file.path(scratch_dir,username,"mimic")
Sys.setenv(OUTDIR=out_dir)

Sys.getenv("SLURM_CPUS_PER_TASK") %>% # use as many cpus as were allocated by SLURM
  as.integer %>%
  suppressWarnings ->
  num_cpus
if (is.na(num_cpus)){num_cpus=1} # use 1 CPU if $SLURM_CPUS_PER_TASK is not defined (or is not an integer)
Sys.setenv(NUM_CPUS=num_cpus)

#------------------------
# Demultiplexing
#------------------------
atacama_data_percent = "1" # may need to be tweaked later
mimic_data_dir = file.path(data_dir)
mimic_md5sum = file.path(mimic_data_dir, "md5_checksum.txt")
map_file = file.path(mimic_data_dir,"230428_Williams_16sFWD_230426.txt")
barcode_fastq = file.path(mimic_data_dir,"Undetermined_S0_L001_I1_001.fastq.gz")
r1_fastq = file.path(mimic_data_dir,"Undetermined_S0_L001_R1_001.fastq.gz")
r2_fastq = file.path(mimic_data_dir,"Undetermined_S0_L001_R2_001.fastq.gz")

demux_dir = file.path(out_dir, "demux")
barcode_table = file.path(demux_dir,"barcodes_for_fastqmultx.tsv")
rc_barcode_table = file.path(demux_dir,"rc_barcodes_for_fastqmultx.tsv")
demux_stdout = file.path(demux_dir,"demux_stdout.txt")
rc_demux_stdout = file.path(demux_dir,"rc_demux_stdout.txt")

Sys.setenv(BARCODE_TABLE=barcode_table,
           RC_BARCODE_TABLE=rc_barcode_table,
           BARCODE_FASTQ=barcode_fastq,
           R1_FASTQ=r1_fastq,
           R2_FASTQ=r2_fastq,
           DEMUX_DIR=demux_dir,
           DEMUX_STDOUT=demux_stdout,
           RC_DEMUX_STDOUT=rc_demux_stdout)


#------------------------
# Amplicon References
#------------------------
dada2_ref_dir = file.path(ref_dir, "dada_references")
silva_ref = file.path(dada2_ref_dir, "silva_nr_v132_train_set.fa.gz")
silva_species_ref = file.path(dada2_ref_dir, "silva_species_assignment_v132.fa.gz")
ref_md5_file = file.path(dada2_ref_dir, "md5sum.txt")

#------------------------
# Amplicon Bioinformatics
#------------------------
# raw data
amplicon_data_dir = file.path(data_dir, "mimic_amplicon")
amplicon_fastq_md5_file = file.path(amplicon_data_dir, "md5_checksums.txt")
amplicon_subsample_dir = file.path(subsample_dir, "mimic_amplicon")
amplicon_subsample_md5_file = file.path(subsample_dir, "mimic_amplicon_md5sums.txt")

# user-specific output paths
amplicon_dir=file.path(out_dir, "amplicon")
dada_out_dir = file.path(amplicon_dir, "dada2")
#   from 01_dada2_tutorial.Rmd
amplicon_ps_rds = file.path(dada_out_dir, "mimic_amplicon.rds")
amplicon_ps_wtree_rds = file.path(dada_out_dir, "mimic_amplicon_wtree.rds")
amplicon_tree_dir = file.path(amplicon_dir, "tree")

Sys.setenv(RAXML_NUM_BOOTSTRAP=100,
           RAXML_OUTDIR=amplicon_tree_dir)

# output directories for common-use
amplicon_results_group_dir <- file.path(results_dir, "amplicon")
dada_results_group_dir <- file.path(amplicon_results_group_dir, "dada2")
asv_seqtab <- file.path(dada_results_group_dir, "mimic_seqtab.rds")
asv_taxa <- file.path(dada_results_group_dir, "mimic_taxa.rds")
amplicon_ps_group_dir <- file.path(amplicon_results_group_dir, "ps")
amplicon_tree_group_dir <- file.path(amplicon_results_group_dir, "tree")

## Phyloseq objects

# Made by /content/amplicon/prep/X1_dada2_fullDataset.Rmd
# Raw data
amplicon_ps_fulldata <- file.path(amplicon_ps_group_dir, "matson_amplicon_fulldata.rds") 

# Made by /content/amplicon/prep/X2_make-phylogenetic-tree_fullDataset.Rmd
# Only keep ASVs where Kingdom == Bacteria
amplicon_ps_fulldata_filt <- file.path(amplicon_ps_group_dir, "matson_amplicon_fulldata_filt.rds") 

# Only keep ASVs where Kingdom == Bacteria AND added phylogenetic tree
amplicons_ps_fulldata_filt_tree <- file.path(amplicon_ps_group_dir, "matson_amplicon_fulldata_filt_tree.rds")



#------------------------
# Shotgun Bioinformatics
#------------------------
# raw data
shotgun_data_dir = file.path(data_dir, "matson_shotgun")
shotgun_fastq_md5_file = file.path(shotgun_data_dir, "md5_checksums.txt")
shotgun_subsample_dir = file.path(subsample_dir, "matson_shotgun")
shotgun_subsample_md5_file = file.path(subsample_dir, "matson_shotgun_md5sums.txt")

# user-specific output paths
shotgun_out_dir = file.path(out_dir, "matson_shotgun")
#   from preprocessing.Rmd
user_fastqc_init_dir = file.path(shotgun_out_dir, "fastqc_init")
user_multiqc_init_dir = file.path(shotgun_out_dir, "multiqc_init")
user_trim_dir = file.path(shotgun_out_dir, "trimmomatic")
user_fastqc_trim_dir = file.path(shotgun_out_dir, "fastqc_trim")
user_multiqc_trim_dir = file.path(shotgun_out_dir, "multiqc_trim")
user_kraken2_dir = file.path(shotgun_out_dir, "kraken2")
user_bracken_dir = file.path(shotgun_out_dir, "bracken")
kraken2_db_ver = "k2_standard_08gb_20230314"
kraken2_db_top <- file.path(ref_dir, "kraken2")
kraken2_db_dir = file.path(kraken2_db_top, kraken2_db_ver)

subset_kraken2_final_csv = file.path(user_bracken_dir, "combined_data.csv")
subset_kraken2_ps_rds = file.path(shotgun_out_dir, "subset_kraken2_ps.rds")


Sys.setenv(FASTQC_INIT_DIR=user_fastqc_init_dir,
           SHOTGUN_SUBSAMPLE_DIR=shotgun_subsample_dir,
           MULTIQC_INIT_DIR=user_multiqc_init_dir,
           TRIM_OUT_DIR=user_trim_dir,
           FASTQC_TRIM_DIR=user_fastqc_trim_dir,
           MULTIQC_TRIM_DIR=user_multiqc_trim_dir,
           KRAKEN2_OUTDIR=user_kraken2_dir,
           KRAKEN_DB_DIR=kraken2_db_dir,
           BRACKEN_OUTDIR=user_bracken_dir)

# paths to remove/update?
# kaiju_db_top <- file.path(ref_dir, "kaiju")
# kaiju_out_top = file.path(shotgun_out_dir, "kaiju")

# output directories for common-use
shotgun_results_dir <- file.path(results_dir, "matson_shotgun")
kaiju_taxonids_tsv <- "/hpc/group/mic-2023/results/matson_shotgun/kaiju/refseq/kaiju_multi_species_table.tsv"
kraken2_taxonids_rds <- "/hpc/group/mic-2023/results/matson_shotgun/bracken/combined_data.rds"

kaiju_results_dir <- file.path(shotgun_results_dir, "kaiju")
kaiju_ds_results_dir <- file.path(shotgun_results_dir, "kaiju_downstream") 
kaiju_ps_dir <- file.path(kaiju_ds_results_dir, "ps") 
kaiju_tree_dir <- file.path(kaiju_ds_results_dir, "tree") 

kraken2_results_dir <- file.path(shotgun_results_dir, "kraken2")
kraken2_ds_results_dir <- file.path(shotgun_results_dir, "kraken2_downstream")
kraken2_ps_dir <- file.path(kraken2_ds_results_dir, "ps") 
kraken2_tree_dir <- file.path(kraken2_ds_results_dir, "tree")

## Phyloseq objects
# Made by content/shotgun/prep/XX_make-phyloseq.Rmd
# Raw data
kaiju_ps <- file.path(kaiju_ps_dir,"ps.RDS")
kraken2_ps <- file.path(kraken2_ps_dir,"ps.RDS")

# Raw data with phylogenetic tree added
kaiju_ps_wtree <- file.path(kaiju_ps_dir, "ps_wtree.RDS")
kraken2_ps_wtree <- file.path(kraken2_ps_dir, "ps_wtree.RDS")


#------------------------
# Miscellaneous 
#------------------------



