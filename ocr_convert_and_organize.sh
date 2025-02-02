#!/bin/bash
# ocr_convert_and_organize.sh
#
# This script converts each image in the given folder into an OCR searchable PDF,
# then extracts text from that PDF into a TXT file.
# After processing, it organizes the files into subfolders:
#   - Original images (png, jpg, jpeg, bmp, tiff, heic) → img/
#   - PDF files → pdf/
#   - TXT files → txt/
#
# Requirements:
#   - ImageMagick v7+ (using the "magick" command)
#   - ocrmypdf
#   - pdftotext (from Poppler)
#   - libheif
#
# Usage:
#   ./ocr_convert_and_organize.sh /path/to/folder

# Exit immediately if a command fails.
set -e

# Check if a folder path is provided.
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 /path/to/folder"
  exit 1
fi

TARGET_DIR="$1"

# Verify that the provided path is a directory.
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: '$TARGET_DIR' is not a valid directory."
  exit 1
fi

# Change to the target directory.
cd "$TARGET_DIR"

# Check if required commands are available.
for cmd in magick ocrmypdf pdftotext; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: '$cmd' is not installed. Please install it and try again."
    exit 1
  fi
done

# Enable nullglob so that globs with no matches expand to nothing.
shopt -s nullglob

# Define an array with the image file patterns (including HEIC variants).
image_files=( *.png *.jpg *.jpeg *.bmp *.tiff *.heic *.HEIC )

# If no image files are found, exit.
if [ ${#image_files[@]} -eq 0 ]; then
  echo "No image files found in '$TARGET_DIR'."
  exit 0
fi

# Process each image file.
for image in "${image_files[@]}"; do
  echo "Processing '$image'..."

  # Get the base name (filename without extension).
  base="${image%.*}"
  output_pdf="${base}.pdf"
  output_txt="${base}.txt"

  # Create a temporary PDF file.
  temp_pdf=$(mktemp /tmp/temp_pdf.XXXXXX.pdf)

  # Convert the image to a PDF using ImageMagick's magick command.
  if ! magick "$image" "$temp_pdf"; then
    echo "Error: Failed to convert '$image' to PDF."
    rm -f "$temp_pdf"
    continue
  fi

  # Add an OCR text layer using ocrmypdf.
  if ! ocrmypdf "$temp_pdf" "$output_pdf" --skip-text; then
    echo "Error: OCR process failed for '$temp_pdf'."
    rm -f "$temp_pdf"
    continue
  fi

  # Remove the temporary PDF.
  rm -f "$temp_pdf"

  # Extract text from the OCR searchable PDF using pdftotext.
  if ! pdftotext "$output_pdf" "$output_txt"; then
    echo "Error: Failed to extract text from '$output_pdf'."
    continue
  fi

  echo "Created '$output_pdf' and '$output_txt'."
done

echo "All files processed."

# ------------------------------
# Organize files into subdirectories.
# ------------------------------

# Create the subfolders if they don't exist.
mkdir -p img pdf txt

# Move original image files to the png folder.
for ext in png jpg jpeg bmp tiff heic HEIC; do
  for file in *."$ext"; do
    if [ -f "$file" ]; then
      echo "Moving '$file' to img/"
      mv "$file" img/
    fi
  done
done

# Move PDF files to the pdf folder.
for file in *.pdf; do
  if [ -f "$file" ]; then
    echo "Moving '$file' to pdf/"
    mv "$file" pdf/
  fi
done

# Move TXT files to the txt folder.
for file in *.txt; do
  if [ -f "$file" ]; then
    echo "Moving '$file' to txt/"
    mv "$file" txt/
  fi
done

echo "Files organized into subfolders."
