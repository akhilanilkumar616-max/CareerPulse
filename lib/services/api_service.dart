import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../core/constants/api_constants.dart';
import '../models/analysis_result.dart';
import 'resume_service.dart';

/// Service for communication with the FastAPI Resume Analysis Backend
class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Health check endpoint verification
  Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.healthEndpoint}');
      final response = await _client.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'ok';
      }
      return false;
    } catch (e) {
      debugPrint('Backend health check failed: $e');
      return false;
    }
  }

  /// Analyze uploaded resume against job description via FastAPI
  Future<AnalysisResult> analyzeResume({
    required SelectedResumeFile resumeFile,
    required String jobTitle,
    String? companyName,
    required String jobDescription,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.analyzeResumeEndpoint}');

    try {
      final request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields['job_title'] = jobTitle.trim();
      if (companyName != null && companyName.trim().isNotEmpty) {
        request.fields['company_name'] = companyName.trim();
      }
      request.fields['job_description'] = jobDescription.trim();

      // Attach PDF file
      if (resumeFile.bytes != null && resumeFile.bytes!.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'resume',
            resumeFile.bytes!,
            filename: resumeFile.name,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      } else if (resumeFile.path != null && resumeFile.path!.isNotEmpty) {
        final file = File(resumeFile.path!);
        final bytes = await file.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'resume',
            bytes,
            filename: resumeFile.name,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      } else {
        throw 'Cannot read resume file bytes. Please try selecting the file again.';
      }

      // Send request with sensible timeout
      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 60),
            onTimeout: () => throw 'Analysis request timed out. Please check if the backend is running.',
          );

      final responseBody = await streamedResponse.stream.bytesToString();
      final statusCode = streamedResponse.statusCode;

      if (statusCode == 200) {
        final json = jsonDecode(responseBody) as Map<String, dynamic>;
        final String generatedId = 'res_${DateTime.now().millisecondsSinceEpoch}';

        return AnalysisResult.fromApiResponse(
          json,
          resultId: generatedId,
          jobTitle: jobTitle,
          companyName: companyName,
          resumeFileName: resumeFile.name,
        );
      } else {
        String errorMessage = 'Analysis failed with status code $statusCode';
        try {
          final errJson = jsonDecode(responseBody);
          if (errJson is Map && errJson.containsKey('detail')) {
            errorMessage = errJson['detail'].toString();
          }
        } catch (_) {
          errorMessage = responseBody.isNotEmpty ? responseBody : errorMessage;
        }
        throw errorMessage;
      }
    } on SocketException catch (_) {
      throw 'Resume analysis service is currently unreachable. Please ensure the backend server is started at ${ApiConstants.baseUrl}.';
    } catch (e) {
      if (e is String) rethrow;
      throw 'Failed to analyze resume: $e';
    }
  }
}
