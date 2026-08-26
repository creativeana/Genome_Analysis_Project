#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 00:30:00
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -J bwa
#SBATCH --output=%x.%j.out

module load BWA
module load SAMtools

REF=/home/anca5290/Documents/Genome_Analysis_Project/03_Genome_Alignment/canu_pacbio_output/Efaecium.contigs.fasta

# Remember to change me
READ1=/home/anca5290/Documents/Genome_Analysis_Project/02_trimming/trimmomatic/trimmed_Illumina/E745_1.paired.fastq.gz
READ2=/home/anca5290/Documents/Genome_Analysis_Project/02_trimming/trimmomatic/trimmed_Illumina/E745_2.paired.fastq.gz

# Remember to change me
OUT=efaecium_illumina_genome_sorted


# Index genome
bwa index "$REF"

# Align
bwa mem -t 4 "$REF" "$READ1" "$READ2" > "$OUT.sam"

# Convert to BAM
samtools view -bS "$OUT.sam" > "$OUT.bam"

# Sort BAM
samtools sort "$OUT.bam" -o "$OUT.sorted.bam"

# Index BAM
samtools index "$OUT.sorted.bam"

