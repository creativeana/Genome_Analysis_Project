#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 07:00:00
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -J blast_genome
#SBATCH --output=%x.%j.out

module load BLAST+

QUERY=/home/anca5290/Documents/Genome_Analysis_Project/03_Genome_Alignment/canu_pacbio_output/Efaecium.contigs.fasta

OUTDIR=/home/anca5290/Documents/Genome_Analysis_Project/09_Validation
mkdir -p "$OUTDIR"

blastx \
  -query "$QUERY" \
  -db refseq_protein \
  -outfmt "6 qseqid sseqid pident length evalue bitscore stitle" \
  -max_target_seqs 30 \
  -num_threads 4 \
  -out "$OUTDIR/blast_results.txt"
