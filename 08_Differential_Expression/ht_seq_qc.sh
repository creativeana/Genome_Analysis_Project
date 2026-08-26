#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -t 00:10:00
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -J htseq_qc
#SBATCH --output=%x.%j.out

set -euo pipefail

REPORT="htseq_qc_report_$(date +%Y%m%d_%H%M%S).txt"

# Redirect all output to both terminal and report file
exec > >(tee "$REPORT") 2>&1

echo "========================================="
echo "HTSeq Output Quality Check"
echo "========================================="
echo "Date: $(date)"
echo "Directory: $(pwd)"
echo

# Check that HTSeq count files exist
if ! ls ERR*.counts.txt >/dev/null 2>&1
then
    echo "ERROR: No HTSeq count files found."
    exit 1
fi

echo "Assigned reads per sample"
echo "-------------------------"

for f in ERR*.counts.txt
do
    echo "$f"
    grep -v "^__" "$f" | awk '{assigned+=$2} END {print assigned}'
done

echo
echo "========================================="
echo "Detailed statistics"
echo "========================================="
echo

for f in ERR*.counts.txt
do
    echo "Sample: $f"

    ASSIGNED=$(grep -v "^__" "$f" | awk '{assigned+=$2} END {print assigned}')

    TOTAL_GENES=$(grep -v "^__" "$f" | wc -l)

    EXPRESSED_GENES=$(grep -v "^__" "$f" | awk '$2>0' | wc -l)

    EXPRESSION_RATE=$(awk \
        -v expressed="$EXPRESSED_GENES" \
        -v total="$TOTAL_GENES" \
        'BEGIN {printf "%.2f", (expressed/total)*100}')

    NO_FEATURE=$(grep "^__no_feature" "$f" | awk '{print $2}')

    AMBIGUOUS=$(grep "^__ambiguous" "$f" | awk '{print $2}')

    LOW_QUAL=$(grep "^__too_low_aQual" "$f" | awk '{print $2}')

    NOT_ALIGNED=$(grep "^__not_aligned" "$f" | awk '{print $2}')

    echo "Assigned reads: $ASSIGNED"
    echo "Annotated genes: $TOTAL_GENES"
    echo "Expressed genes: $EXPRESSED_GENES (${EXPRESSION_RATE}%)"
    echo "__no_feature: $NO_FEATURE"
    echo "__ambiguous: $AMBIGUOUS"
    echo "__too_low_aQual: $LOW_QUAL"
    echo "__not_aligned: $NOT_ALIGNED"
    echo
done

echo "========================================="
echo "QC complete"
echo "Report saved as: $REPORT"
echo "========================================="
