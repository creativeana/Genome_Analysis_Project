#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 02:00:00
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -J htseq
#SBATCH --output=%x.%j.out

module load HTSeq

# Run htSeq
htseq-count \
  -f bam \
  -r pos \
  -s no \
  -t CDS \
  -i locus_tag \
  /home/anca5290/Documents/Genome_Analysis_Project/07_Aligner/illumina_genome_bwa/efaecium_illumina_genome_sorted.bam \
  /home/anca5290/Documents/Genome_Analysis_Project/05_Annotation/prokka_output/Efaecium_fixed.gff \
  > illumina_genome_htseq.counts.txt
