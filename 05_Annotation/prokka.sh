#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 00:10:00
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J prokka
#SBATCH --output=%x.%j.out
#SBATCH --mail-type=ALL

module load prokka

prokka \
  --outdir prokka_output \
  --prefix Efaecium \
  --genus Enterococcus \
  --species faecium \
  /home/anca5290/Documents/Genome_Analysis_Project/03_Genome_Alignment/canu_pacbio_output/Efaecium.contigs.fasta
