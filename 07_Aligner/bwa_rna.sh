#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 04:00:00
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -J bwa_rna
#SBATCH --output=%x.%j.out

module load BWA
module load SAMtools

# Reference genome (your CANU assembly)
REF=/home/anca5290/Documents/Genome_Analysis_Project/03_Genome_Alignment/canu_pacbio_output/Efaecium.contigs.fasta

# Trimmed read directories
BH_DIR=/home/anca5290/Documents/Genome_Analysis_Project/02_trimming/trimmomatic/trimmed_RNA-Seq_BH
SERUM_DIR=/home/anca5290/Documents/Genome_Analysis_Project/02_trimming/trimmomatic/trimmed_RNA-Seq_Serum

# -------------------------
# BH samples
# -------------------------
for SAMPLE in ERR1797972 ERR1797973 ERR1797974
do
  echo "Mapping BH sample: $SAMPLE"

  bwa mem -t 4 "$REF" \
    "$BH_DIR/${SAMPLE}_1.paired.fq.gz" \
    "$BH_DIR/${SAMPLE}_2.paired.fq.gz" | \
  samtools sort -o ${SAMPLE}.sorted.bam

  samtools index ${SAMPLE}.sorted.bam
done

# -------------------------
# Serum samples
# -------------------------
for SAMPLE in ERR1797969 ERR1797970 ERR1797971
do
  echo "Mapping Serum sample: $SAMPLE"

  bwa mem -t 4 "$REF" \
    "$SERUM_DIR/${SAMPLE}_1.paired.fq.gz" \
    "$SERUM_DIR/${SAMPLE}_2.paired.fq.gz" | \
  samtools sort -o ${SAMPLE}.sorted.bam

  samtools index ${SAMPLE}.sorted.bam
done
