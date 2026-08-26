#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 00:15:00
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -J gene_to_function
#SBATCH --output=%x.%j.out

tail -n +2 DESeq2_output.csv \
| grep -v ",NA,NA,NA,NA,NA,NA" \
| sort -t, -k7,7g \
| head -100 \
| cut -d',' -f1 \
| tr -d '"' \
> top100_gene_ids.txt
echo "top 100 DE genes concluded successfully."


grep -F -f top100_gene_ids.txt \
../05_Annotation/eggnog_Efaecium.emapper.annotations \
> top100_genes_annotated.tsv
echo "Annotation concluded successfully."

awk -F '\t' '
{
    print $1 "\t" $8 "\t" $9
}
' top100_genes_annotated.tsv \
> top100_gene_to_functions.tsv

echo "Gene function extracted successfully."

echo "Outputs:"
echo "  top100_gene_ids.txt"
echo "  top100_genes_annotated.tsv"
echo "  top100_gene_to_functions.tsv"
