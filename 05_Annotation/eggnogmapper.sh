#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 13:00:00
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -J eggnog
#SBATCH --output=%x.%j.out

module load eggnog-mapper

emapper.py \
  -i /home/anca5290/Documents/Genome_Analysis_Project/05_Annotation/prokka_output/Efaecium.faa \
  -o eggnog_Efaecium \
  --itype proteins \
  --cpu 4 \
  --tax_scope bacteria \
  --decorate_gff yes \
  --go_evidence non-electronic \
  --data_dir /home/anca5290/Documents/Genome_Analysis_Project/05_Annotation/resources/eggnog-mapper/rackham
