#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 03:00:00
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -J canu_pacbio
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

# Load module
module load canu
module load SAMtools/1.22-GCC-13.3.0

# CANU Commands
canu \
  -p Efaecium \
  -d canu_pacbio_output \
  genomeSize=2.8m \
  useGrid=false \
  maxThreads=4 \
  -pacbio-raw /proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/genomics_data/PacBio/*.fastq.gz
