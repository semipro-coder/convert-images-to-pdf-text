```markdown
# OCR Convert and Organize

This repository contains a Bash script that processes images in a given folder by converting them into OCR searchable PDFs and extracting their text into TXT files. After processing, the script organizes the original images, PDFs, and text files into dedicated subfolders.

## Features

- **Image Conversion:**  
  Converts common image formats (PNG, JPG, JPEG, BMP, TIFF, HEIC) to PDF using ImageMagick v7.
- **OCR Processing:**  
  Adds an OCR text layer to PDFs using `ocrmypdf`.
- **Text Extraction:**  
  Extracts text from the OCR searchable PDFs using `pdftotext` (from Poppler).
- **File Organization:**  
  Organizes files into:
  - `img/` for original image files,
  - `pdf/` for the generated PDFs, and
  - `txt/` for the extracted text files.

## Requirements

Ensure the following packages are installed and available in your system's PATH:

- **ImageMagick v7+**  
  Provides the `magick` command.
  - **HEIC Support:**  
    For processing HEIC images, install [libheif](https://github.com/strukturag/libheif).
  - **Installation on macOS:**  
    ```bash
    brew install imagemagick
    brew install libheif
    ```
- **ocrmypdf**  
  Adds an OCR layer to PDFs.
  - **Installation via pip:**  
    ```bash
    pip install ocrmypdf
    ```
- **Poppler (pdftotext)**  
  Extracts text from PDFs.
  - **Installation on macOS:**  
    ```bash
    brew install poppler
    ```

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/ocr-convert-and-organize.git
   cd ocr-convert-and-organize
   ```

2. **Make the script executable:**

   ```bash
   chmod +x ocr_convert_and_organize.sh
   ```

## Usage

Run the script by providing the path to the folder containing your images. For example:

```bash
./ocr_convert_and_organize.sh /path/to/your/images
```

The script will:

1. **Process each image** in the specified directory:
   - Convert it to a PDF using ImageMagick.
   - Run OCR on the PDF with `ocrmypdf`.
   - Extract text from the OCR PDF using `pdftotext`.

2. **Organize the files** by moving them into subdirectories:
   - Original images are moved to the `png/` folder.
   - Generated PDFs are moved to the `pdf/` folder.
   - Extracted TXT files are moved to the `txt/` folder.

## Troubleshooting

- **Command Not Found:**  
  Ensure that `magick`, `ocrmypdf`, and `pdftotext` are installed and that your PATH is set correctly.
- **HEIC Processing Issues:**  
  Verify that `libheif` is installed and that your ImageMagick installation includes HEIC support.

## License

This project is open source and available under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or suggestions.
```
