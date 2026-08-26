#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 00:20:00
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J fastqc_BH
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load bioinfo-tools
module load FastQC

INPUT_DIR=/home/anca5290/Documents/Genome_Analysis_Project/02_trimming/trimmomatic/trimmed_RNA-Seq_BH
OUT_DIR=/home/anca5290/Documents/Genome_Analysis_Project/02_trimming/trimmomatic/output_post_trim_fastqc_RNA-Seq_BH

mkdir -p "$OUT_DIR"

fastqc -t 2 \
  "$INPUT_DIR"/*.paired.fq.gz \
  -o "$OUT_DIR"
