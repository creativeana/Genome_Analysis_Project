#!/bin/bash -l 
#SBATCH -A uppmax2026-1-61 
#SBATCH -t 00:10:00 
#SBATCH -p pelle 
#SBATCH -c 2 
#SBATCH -J trimming_fastqc 
#SBATCH --mail-type=ALL 
#SBATCH --output=%x.%j.out 

# Load modules
module load FastQC


# Code - commands
fastqc -t 2 \
  /home/anca5290/Documents/Genome_Analysis_Project/02_trimming/trimmomatic/trimmed_RNA-Seq_BH/*.fq.gz \
  -o .
