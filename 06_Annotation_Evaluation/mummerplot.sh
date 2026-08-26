#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 00:30:00
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J mummerplot
#SBATCH --output=%x.%j.out

module load MUMmer

# Alignment
nucmer --prefix=efaecium \
  /home/anca5290/Documents/Genome_Analysis_Project/06_Annotation_Evaluation/reference_genome.fasta \
  /home/anca5290/Documents/Genome_Analysis_Project/03_Genome_Alignment/canu_pacbio_output/Efaecium.contigs.fasta

# Filtering
delta-filter -1 efaecium.delta > efaecium.filter

# Plotting
mummerplot --png \
           --prefix=e_faecium_plot \
           efaecium.filter
