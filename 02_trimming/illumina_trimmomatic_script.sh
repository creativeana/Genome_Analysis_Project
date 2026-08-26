#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 00:30:00
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -J trimming_trimmomatic
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

# Load modules
module load Trimmomatic


INPUT_DIR=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/genomics_data/Illumina
OUT_DIR=trimmed_Illumina

mkdir -p $OUT_DIR

trimmomatic PE -threads 4 \
  $INPUT_DIR/E745-1.L500_SZAXPI015146-56_1_clean.fq.gz \
  $INPUT_DIR/E745-1.L500_SZAXPI015146-56_2_clean.fq.gz \
  $OUT_DIR/E745_1.paired.fastq.gz \
  $OUT_DIR/E745_1.unpaired.fastq.gz \
  $OUT_DIR/E745_2.paired.fastq.gz \
  $OUT_DIR/E745_2.unpaired.fastq.gz \
  ILLUMINACLIP:/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa:2:30:10 \
  SLIDINGWINDOW:4:20 \
  MINLEN:36
