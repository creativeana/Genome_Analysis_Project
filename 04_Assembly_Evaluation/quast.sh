#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 00:20:00
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -J quast
#SBATCH --output=%x.%j.out
#SBATCH --mail-type=ALL

module load QUAST

quast /home/anca5290/Documents/Genome_Analysis_Project/03_Genome_Alignment/canu_pacbio_output/Efaecium.contigs.fasta -o quast_output
