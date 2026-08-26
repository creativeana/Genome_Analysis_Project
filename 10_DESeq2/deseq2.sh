#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 00:15:00
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -J deseq2
#SBATCH --output=%x.%j.out

# Module
module load R-bundle-Bioconductor/3.20-foss-2024a-R-4.4.2
module spider DESeq2

#Command
Rscript deseq2_r.R
