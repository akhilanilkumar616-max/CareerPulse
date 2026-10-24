import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';

/// Representation of a selected Resume file
class SelectedResumeFile {
  final String name;
  final int sizeInBytes;
  final Uint8List? bytes;
  final String? path;

  SelectedResumeFile({
    required this.name,
    required this.sizeInBytes,
    this.bytes,
    this.path,
  });

  String get formattedSize {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  bool get isPdf => name.toLowerCase().endsWith('.pdf');
}

/// Service handling Resume picking and validation
class ResumeService {
  /// Open system file picker to select a PDF resume
  Future<SelectedResumeFile?> pickResumeFile() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (files.isEmpty) {
        return null;
      }

      final file = files.first;

      // Validate PDF extension
      if (!file.name.toLowerCase().endsWith('.pdf')) {
        throw 'Please select a valid PDF file (.pdf).';
      }

      final bytes = await file.readAsBytes();
      final size = file.lengthSync() ?? bytes.length;

      // Validate file size limit
      if (size > AppConstants.maxFileSizeInBytes) {
        throw 'File size exceeds maximum limit of 5 MB.';
      }

      return SelectedResumeFile(
        name: file.name,
        sizeInBytes: size,
        bytes: bytes,
        path: file.path,
      );
    } catch (e) {
      if (e is String) rethrow;
      throw 'Failed to pick file: $e';
    }
  }
}
