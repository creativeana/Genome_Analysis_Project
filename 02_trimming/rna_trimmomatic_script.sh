#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 03:00:00
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -J trim_RNA
#SBATCH --output=%x.%j.out

module load Trimmomatic

# Input directories
BH_DIR=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_BH/raw
SERUM_DIR=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_Serum/raw

# Output directories
OUT_BH=trimmed_RNA-Seq_BH
OUT_SERUM=trimmed_RNA-Seq_Serum

mkdir -p "$OUT_BH"
mkdir -p "$OUT_SERUM"

echo "Starting RNA-Seq trimming..."


# BH samples
for SAMPLE in ERR1797972 ERR1797973 ERR1797974
do
  echo "Processing BH sample: $SAMPLE"

  trimmomatic PE -threads 4 \
    "$BH_DIR/${SAMPLE}_1.fastq.gz" "$BH_DIR/${SAMPLE}_2.fastq.gz" \
    "$OUT_BH/${SAMPLE}_1.paired.fq.gz" "$OUT_BH/${SAMPLE}_1.unpaired.fq.gz" \
    "$OUT_BH/${SAMPLE}_2.paired.fq.gz" "$OUT_BH/${SAMPLE}_2.unpaired.fq.gz" \
    ILLUMINACLIP:/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa:2:30:10 \
    SLIDINGWINDOW:4:20 \
    MINLEN:36
done


# Serum samples
for SAMPLE in ERR1797969 ERR1797970 ERR1797971
do
  echo "Processing Serum sample: $SAMPLE"

  trimmomatic PE -threads 4 \
    "$SERUM_DIR/${SAMPLE}_1.fastq.gz" "$SERUM_DIR/${SAMPLE}_2.fastq.gz" \
    "$OUT_SERUM/${SAMPLE}_1.paired.fq.gz" "$OUT_SERUM/${SAMPLE}_1.unpaired.fq.gz" \
    "$OUT_SERUM/${SAMPLE}_2.paired.fq.gz" "$OUT_SERUM/${SAMPLE}_2.unpaired.fq.gz" \
    ILLUMINACLIP:/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa:2:30:10 \
    SLIDINGWINDOW:4:20 \
    MINLEN:36
done

echo "RNA-Seq trimming completed!"
