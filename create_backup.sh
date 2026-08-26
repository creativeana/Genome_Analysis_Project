#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -t 00:15:00
#SBATCH -c 2
#SBATCH -J github_backup
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

###############################################################################
# SETTINGS
###############################################################################

# Set to true to preview only
# Set to false to actually copy files

DRYRUN=false

SOURCE="/home/anca5290/Documents/Genome_Analysis_Project"
BACKUP="/home/anca5290/Documents/BACKUP_Genome_Analysis_Project"

###############################################################################
##    echo
#    echo "Creating compressed archive..."

#    tar -czf \
#    /home/anca5290/Documents/BACKUP_Genome_Analysis_Project.tar.gz \
#    -C /home/anca5290/Documents \
#    BACKUP_Genome_Analysis_Project

#    echo
#    echo "Archive created:"
#    echo "/home/anca5290/Documents/BACKUP_Genome_Analysis_Project.tar.gz" FUNCTIONS
###############################################################################

copy_file() {
    local SRC="$1"
    local DEST="$2"

    if [[ -f "$SRC" ]]; then
        if $DRYRUN; then
            echo "[COPY] $SRC"
            echo "       -> $DEST"
        else
            cp "$SRC" "$DEST"
        fi
    fi
}

copy_find() {
    local SRC_DIR="$1"
    local DEST_DIR="$2"

    shift 2

    while IFS= read -r FILE; do

        if $DRYRUN; then

            echo "[COPY] $FILE"
            echo "       -> $DEST_DIR"

        else

            cp "$FILE" "$DEST_DIR"

        fi

    done < <(find "$SRC_DIR" "$@")
}

###############################################################################
# CHECK SOURCE
###############################################################################

echo "Source : $SOURCE"
echo "Backup : $BACKUP"
echo "DryRun : $DRYRUN"
echo

if [[ ! -d "$SOURCE" ]]; then
    echo "ERROR: Source folder not found."
    exit 1
fi

###############################################################################
# CREATE BACKUP STRUCTURE
###############################################################################

if ! $DRYRUN; then

mkdir -p "$BACKUP/02_trimming"
mkdir -p "$BACKUP/03_Genome_Alignment"
mkdir -p "$BACKUP/04_Assembly_Evaluation"
mkdir -p "$BACKUP/05_Annotation"
mkdir -p "$BACKUP/06_Annotation_Evaluation"
mkdir -p "$BACKUP/07_Aligner"
mkdir -p "$BACKUP/08_Differential_Expression"
mkdir -p "$BACKUP/09_Validation"
mkdir -p "$BACKUP/10_DESeq2"

fi

###############################################################################
# 02 TRIMMING
###############################################################################

echo
echo "===== 02_trimming ====="

copy_find \
"$SOURCE/02_trimming" \
"$BACKUP/02_trimming" \
\( -name "*fastqc.html" -o \
   -name "*.sh" \)

###############################################################################
# 03 GENOME ALIGNMENT
###############################################################################

echo
echo "===== 03_Genome_Alignment ====="

copy_file \
"$SOURCE/03_Genome_Alignment/canu_script.sh" \
"$BACKUP/03_Genome_Alignment"

copy_file \
"$SOURCE/03_Genome_Alignment/canu_pacbio_output/Efaecium.contigs.fasta" \
"$BACKUP/03_Genome_Alignment"

copy_file \
"$SOURCE/03_Genome_Alignment/canu_pacbio_output/Efaecium.unassembled.fasta" \
"$BACKUP/03_Genome_Alignment"



###############################################################################
# 04_ASSEMBLY_EVALUATION
###############################################################################

echo
echo "===== 04_Assembly_Evaluation ====="

copy_find \
"$SOURCE/04_Assembly_Evaluation" \
"$BACKUP/04_Assembly_Evaluation" \
\( -name "report.pdf" -o \
   -name "report.tsv" -o \
   -name "report.txt" -o \
   -name "short_summary*.txt" -o \
   -name "short_summary*.json" -o \
   -name "*.sh" \)

# BUSCO full tables

copy_file \
"$SOURCE/04_Assembly_Evaluation/busco_enterococcaceae_odb12/run_enterococcaceae_odb12/full_table.tsv" \
"$BACKUP/04_Assembly_Evaluation"

copy_file \
"$SOURCE/04_Assembly_Evaluation/busco_enterococcus_odb12/run_enterococcus_odb12/full_table.tsv" \
"$BACKUP/04_Assembly_Evaluation"

copy_file \
"$SOURCE/04_Assembly_Evaluation/busco_bacteria_odb10/run_bacteria_odb10/full_table.tsv" \
"$BACKUP/04_Assembly_Evaluation"

# Report
copy_file \
"$SOURCE/04_Assembly_Evaluation/quast_output/report.html" \
"$BACKUP/04_Assembly_Evaluation"

###############################################################################
# 05_ANNOTATION
###############################################################################

echo
echo "===== 05_Annotation ====="

copy_file \
"$SOURCE/05_Annotation/prokka_output/Efaecium.gff" \
"$BACKUP/05_Annotation"

copy_file \
"$SOURCE/05_Annotation/prokka_output/Efaecium.gbk" \
"$BACKUP/05_Annotation"

copy_file \
"$SOURCE/05_Annotation/prokka_output/Efaecium.tsv" \
"$BACKUP/05_Annotation"

copy_file \
"$SOURCE/05_Annotation/prokka_output/gene_annotations.txt" \
"$BACKUP/05_Annotation"

copy_file \
"$SOURCE/05_Annotation/eggnog_Efaecium.emapper.annotations" \
"$BACKUP/05_Annotation"

copy_find \
"$SOURCE/05_Annotation" \
"$BACKUP/05_Annotation" \
-maxdepth 1 -name "*.sh"

###############################################################################
# 06_ANNOTATION_EVALUATION
###############################################################################

echo
echo "===== 06_Annotation_Evaluation ====="

# Main outputs

copy_file \
"$SOURCE/06_Annotation_Evaluation/e_faecium_plot.png" \
"$BACKUP/06_Annotation_Evaluation"

copy_file \
"$SOURCE/06_Annotation_Evaluation/reference_genome.fasta" \
"$BACKUP/06_Annotation_Evaluation"

# MUMmer alignment outputs

copy_file \
"$SOURCE/06_Annotation_Evaluation/efaecium.delta" \
"$BACKUP/06_Annotation_Evaluation"

copy_file \
"$SOURCE/06_Annotation_Evaluation/efaecium.filter" \
"$BACKUP/06_Annotation_Evaluation"

# Script

copy_file \
"$SOURCE/06_Annotation_Evaluation/mummerplot.sh" \
"$BACKUP/06_Annotation_Evaluation"

###############################################################################
# 07_ALIGNER
###############################################################################

echo
echo "===== 07_Aligner ====="

copy_find \
"$SOURCE/07_Aligner" \
"$BACKUP/07_Aligner" \
\( -name "*.sh" \)

###############################################################################
# 08 DIFFERENTIAL EXPRESSION
###############################################################################

echo
echo "===== 08_Differential_Expression ====="

copy_find \
"$SOURCE/08_Differential_Expression" \
"$BACKUP/08_Differential_Expression" \
\( -name "*.counts.txt" -o \
   -name "*report*.txt" -o \
   -name "*.sh" \)

###############################################################################
# 09 VALIDATION
###############################################################################

echo
echo "===== 09_Validation ====="

copy_file \
"$SOURCE/09_Validation/blast_results.txt" \
"$BACKUP/09_Validation"

copy_find \
"$SOURCE/09_Validation" \
"$BACKUP/09_Validation" \
-maxdepth 1 -name "*.sh"

###############################################################################
# 10 DESEQ2
###############################################################################

echo
echo "===== 10_DESeq2 ====="

copy_find \
"$SOURCE/10_DESeq2" \
"$BACKUP/10_DESeq2" \
\( -name "*.csv" -o \
   -name "*.tsv" -o \
   -name "*.txt" -o \
   -name "*.png" -o \
   -name "*.R" -o \
   -name "*.sh" \)

###############################################################################
# SUMMARY
###############################################################################

echo
echo "=================================================="
echo "BACKUP JOB FINISHED"
echo "=================================================="

if ! $DRYRUN; then

    echo
    echo "Backup size:"
    du -sh "$BACKUP"

    echo
    echo "Contents of backup:"
    find "$BACKUP" | sort

#    echo
#    echo "Creating compressed archive..."

#    tar -czf \
#    /home/anca5290/Documents/BACKUP_Genome_Analysis_Project.tar.gz \
#    -C /home/anca5290/Documents \
#    BACKUP_Genome_Analysis_Project

#    echo
#    echo "Archive created:"
#    echo "/home/anca5290/Documents/BACKUP_Genome_Analysis_Project.tar.gz"

else

    echo
    echo "Dry run complete."
    echo "No files were copied."

fi
