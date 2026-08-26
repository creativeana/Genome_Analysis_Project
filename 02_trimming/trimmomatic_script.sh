#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 01:00:00
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J trimming_trimmomatic
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

# Load modules
module load Trimmomatic


# Code - commands

for FILE in /proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/genomics_data/Illumina/*.fq.gz
do
  trimmomatic SE -threads 2 \
    "$FILE" \
    "$(basename "$FILE" .fastq.gz)_trimmed.fq.gz" \
    ILLUMINACLIP:/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-SE.fa:2:30:10 \
    SLIDINGWINDOW:4:20 \
    MINLEN:36
done

