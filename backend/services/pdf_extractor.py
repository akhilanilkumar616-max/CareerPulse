import io
import re
from typing import Tuple


class PDFExtractionError(Exception):
    """Custom exception raised when PDF validation or text extraction fails."""
    pass


class PDFExtractor:
    """Service to validate PDF files and extract clean normalized text."""

    MAX_FILE_SIZE = 5 * 1024 * 1024  # 5 MB
    MIN_TEXT_LENGTH = 30  # Minimum characters for a non-scanned, readable resume

    @classmethod
    def validate_and_extract(cls, file_bytes: bytes, filename: str) -> str:
        """
        Validates the PDF bytes and extracts normalized text.
        Raises PDFExtractionError with student-friendly guidance on failure.
        """
        if not file_bytes:
            raise PDFExtractionError("The uploaded file is empty. Please select a valid PDF resume.")

        if len(file_bytes) > cls.MAX_FILE_SIZE:
            raise PDFExtractionError("The uploaded file exceeds the 5 MB limit. Please upload a smaller PDF.")

        # Check PDF Magic Header %PDF-
        if not file_bytes.startswith(b"%PDF-"):
            raise PDFExtractionError("Please upload a valid PDF file. The selected file is not a valid PDF document.")

        try:
            try:
                import pymupdf as fitz
            except ImportError:
                import fitz
            doc = fitz.open(stream=file_bytes, filetype="pdf")
        except Exception as e:
            raise PDFExtractionError(f"Unable to read or parse the PDF document: {str(e)}")

        if doc.is_encrypted:
            try:
                # Attempt empty password decrypt
                authenticated = doc.authenticate("")
                if not authenticated:
                    raise PDFExtractionError("This PDF is password-protected. Please upload an unlocked PDF resume.")
            except Exception:
                raise PDFExtractionError("This PDF is password-protected. Please upload an unlocked PDF resume.")

        total_pages = len(doc)
        if total_pages == 0:
            raise PDFExtractionError("The uploaded PDF does not contain any pages.")

        extracted_text_chunks = []
        for page_num in range(total_pages):
            page = doc.load_page(page_num)
            text = page.get_text("text")
            if text:
                extracted_text_chunks.append(text)

        doc.close()

        full_raw_text = "\n".join(extracted_text_chunks).strip()

        # Handle scanned or image-only PDFs without usable selectable text
        if len(full_raw_text) < cls.MIN_TEXT_LENGTH:
            raise PDFExtractionError(
                "We couldn't extract selectable text from this PDF. "
                "OCR support is not available in this version. "
                "Please upload a text-based PDF resume generated from Word, LaTeX, or Canva."
            )

        return cls.normalize_text(full_raw_text)

    @classmethod
    def normalize_text(cls, text: str) -> str:
        """
        Cleans and normalizes extracted resume or job text while preserving
        technical keywords (e.g., C++, C#, .NET, Node.js).
        """
        # Replace non-breaking spaces and irregular whitespace
        text = text.replace("\u00a0", " ").replace("\r\n", "\n").replace("\r", "\n")

        # Replace multiple consecutive spaces and tabs with single space
        text = re.sub(r"[ \t]+", " ", text)

        # Replace 3 or more newlines with two newlines
        text = re.sub(r"\n{3,}", "\n\n", text)

        # Remove control characters except standard whitespace
        text = re.sub(r"[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]", "", text)

        return text.strip()
