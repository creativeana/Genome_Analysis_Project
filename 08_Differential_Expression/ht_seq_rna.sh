#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 03:30:00
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -J htseq
#SBATCH --output=%x.%j.out

module load HTSeq

# Run htSeq
GFF=/home/anca5290/Documents/Genome_Analysis_Project/05_Annotation/prokka_output/Efaecium_fixed.gff

BH_DIR=/home/anca5290/Documents/Genome_Analysis_Project/07_Aligner/rna_bh_bwa_st
SERUM_DIR=/home/anca5290/Documents/Genome_Analysis_Project/07_Aligner/rna_serum_bwa_st

# 1. BH samples
for SAMPLE in ERR1797972 ERR1797973 ERR1797974
do
  echo "Counting BH sample: $SAMPLE"

  htseq-count \
    -f bam \
    -r pos \
    -s no \
    -t CDS \
    -i locus_tag \
    "$BH_DIR/${SAMPLE}.sorted.bam" \
    "$GFF" \
    > ${SAMPLE}.counts.txt
done

# 2. Serum samples
for SAMPLE in ERR1797969 ERR1797970 ERR1797971
do
  echo "Counting Serum sample: $SAMPLE"

  htseq-count \
    -f bam \
    -r pos \
    -s no \
    -t CDS \
    -i locus_tag \
    "$SERUM_DIR/${SAMPLE}.sorted.bam" \
    "$GFF" \
    > ${SAMPLE}.counts.txt
done
