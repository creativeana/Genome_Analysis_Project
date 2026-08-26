#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 01:00:00
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -J busco
#SBATCH --output=%x.%j.out
#SBATCH --mail-type=ALL

module load BUSCO

# Lineage list
for LINEAGE in bacteria_odb10 enterococcaceae_odb12 enterococcus_odb12
do
  busco -i /home/anca5290/Documents/Genome_Analysis_Project/03_Genome_Alignment/canu_pacbio_output/Efaecium.contigs.fasta \
        -l $BUSCO_LINEAGE_SETS/lineages/$LINEAGE \
        -o busco_${LINEAGE} \
        -m genome
done
