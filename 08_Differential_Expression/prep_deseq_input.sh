#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 00:10:00
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -J prep_deseq2_input
#SBATCH --output=%x.%j.out

#!/bin/bash -l

set -euo pipefail

REPORT="prepare_deseq_input_report_$(date +%Y%m%d_%H%M%S).txt"

exec > >(tee "$REPORT") 2>&1

echo "Preparing DESeq2 Input Files"
echo "Date: $(date)"


# Ensure HTSeq files exist

if ! ls ERR*.counts.txt >/dev/null 2>&1
then
    echo "ERROR: No HTSeq count files found."
    exit 1
fi


for f in ERR*.counts.txt
do

    if [ ! -s "$f" ]
    then
        echo "ERROR: $f is empty."
        exit 1
    fi

    TOTAL_GENES=$(grep -v "^__" "$f" | wc -l)

    if [ "$TOTAL_GENES" -eq 0 ]
    then
        echo "ERROR: No gene counts detected in $f."
        exit 1
    fi

    OUTFILE="../10_DESeq2/${f%.counts.txt}.deseq_input.tsv"

    grep -v "^__" "$f" > "$OUTFILE"

    echo "Created DeSeq2 Files: $OUTFILE"

done

echo
echo "Merging DESeq2 input files..."

paste \
../10_DESeq2/ERR1797969.deseq_input.tsv \
../10_DESeq2/ERR1797970.deseq_input.tsv \
../10_DESeq2/ERR1797971.deseq_input.tsv \
../10_DESeq2/ERR1797972.deseq_input.tsv \
../10_DESeq2/ERR1797973.deseq_input.tsv \
../10_DESeq2/ERR1797974.deseq_input.tsv \
> ../10_DESeq2/merged_counts.tmp

echo "DeSeq2 files merged."

awk '
BEGIN{
    OFS="\t";
    print "Gene","ERR1797969","ERR1797970","ERR1797971","ERR1797972","ERR1797973","ERR1797974"
}
{
    print $1,$2,$4,$6,$8,$10,$12
}
' ../10_DESeq2/merged_counts.tmp \
> ../10_DESeq2/counts_matrix.tsv

LINES=$(wc -l < ../10_DESeq2/counts_matrix.tsv)
echo "Count Matrix created with $LINES lines."

cat > ../10_DESeq2/sample_info.tsv << EOF
sample	condition
ERR1797969	Serum
ERR1797970	Serum
ERR1797971	Serum
ERR1797972	BH
ERR1797973	BH
ERR1797974	BH
EOF

echo "Sample Metadata generated."


echo "Generated files:"
echo "  counts_matrix.tsv"
echo "  sample_info.tsv"

echo "Matrix Created Report saved as: $REPORT"
