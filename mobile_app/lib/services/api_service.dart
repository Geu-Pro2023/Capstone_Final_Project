import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:titweng/models/cow_model.dart';
import 'package:titweng/models/user_model.dart';
import 'package:titweng/utils/api_config.dart';

class ApiService {
  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();
  ApiService._();

  // Note: No mobile auth endpoints available in FastAPI
  // Using mock authentication for now
  Future<UserModel?> authenticateUser(String email, String password) async {
    // Simulate authentication since no mobile auth endpoint exists
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.contains('@') && password.length >= 6) {
      return UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Mobile User',
        email: email,
        phone: '+211987654321',
        role: UserRole.user,
        createdAt: DateTime.now(),
      );
    }
    return null;
  }

  // Note: No mobile user registration endpoints available
  // Using mock registration for now
  Future<UserModel?> createUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    // Simulate user creation since no mobile registration endpoint exists
    await Future.delayed(const Duration(seconds: 2));
    
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: fullName,
      email: email,
      phone: phone,
      role: UserRole.user,
      createdAt: DateTime.now(),
    );
  }

  // Note: No mobile cow registration endpoint available
  // Cow registration is admin-only via /admin/register-cow
  Future<void> registerCow(CowModel cow) async {
    // Simulate cow registration since mobile users cannot register cows
    await Future.delayed(const Duration(seconds: 2));
// Cow registration simulated - admin registration required
  }

  // Note: No mobile endpoint to get all cows
  // Admin-only via /admin/cows
  Future<List<CowModel>> getAllCows() async {
    // Return empty list since mobile users cannot list all cows
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  // 1. POST /mobile/verify/nose - Verify cow by nose print
  Future<CowModel?> verifyByNose(List<String> imagePaths) async {
    try {
      final url = '${ApiConfig.baseUrl}/mobile/verify/nose';
      print('Verifying nose print at: $url');
      
      var request = http.MultipartRequest('POST', Uri.parse(url));
      
      for (String imagePath in imagePaths) {
        var file = await http.MultipartFile.fromPath('files', imagePath);
        request.files.add(file);
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      
      print('Nose verification response status: ${response.statusCode}');
      print('Nose verification response body: $responseBody');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data['cow_found'] == true) {
          final cowData = data['cow_details'];
          return CowModel(
            id: cowData['cow_tag'] ?? '',
            name: 'Cow ${cowData['cow_tag'] ?? 'Unknown'}',
            age: cowData['age'] ?? 0,
            ownerName: cowData['owner_name'] ?? 'Unknown Owner',
            ownerEmail: cowData['owner_email'] ?? '',
            location: cowData['owner_address'] ?? '',
            state: '',
            witness: 'Nose Print Verified',
            noseImagePaths: [],
            registrationDate: DateTime.now(),
          );
        }
      }
    } catch (e) {
      print('Nose verification error: $e');
    }
    return null;
  }

  // 2. GET /mobile/verify/tag/{cow_tag} - Verify cow by tag
  Future<CowModel?> verifyByTag(String cowTag) async {
    try {
      final url = '${ApiConfig.baseUrl}/mobile/verify/tag/$cowTag';
      print('Verifying tag at: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('Tag verification response status: ${response.statusCode}');
      print('Tag verification response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['cow_found'] == true) {
          final cowData = data['cow_details'];
          return CowModel(
            id: cowData['cow_tag'] ?? cowTag,
            name: 'Cow $cowTag',
            age: cowData['age'] ?? 0,
            ownerName: cowData['owner_name'] ?? 'Unknown Owner',
            ownerEmail: cowData['owner_email'] ?? '',
            location: cowData['owner_address'] ?? '',
            state: '',
            witness: 'Tag Verified',
            noseImagePaths: [],
            registrationDate: DateTime.now(),
          );
        }
      }
    } catch (e) {
      print('Tag verification error: $e');
    }
    return null;
  }

  // 3. POST /mobile/report - Submit report
  Future<String> submitReport({
    required String reporterName,
    required String reporterPhone,
    String? reporterEmail,
    String? cowTag,
    required String reportType,
    required String subject,
    required String message,
    String? location,
  }) async {
    try {
      final url = '${ApiConfig.baseUrl}/mobile/report';
      print('Submitting report at: $url');
      
      final body = {
        'reporter_name': reporterName,
        'reporter_phone': reporterPhone,
        'report_type': reportType,
        'subject': subject,
        'message': message,
      };
      
      if (reporterEmail != null) body['reporter_email'] = reporterEmail;
      if (cowTag != null) body['cow_tag'] = cowTag;
      if (location != null) body['location'] = location;
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      
      print('Report submission response status: ${response.statusCode}');
      print('Report submission response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['report_id']?.toString() ?? 'RPT${DateTime.now().millisecondsSinceEpoch}';
      }
    } catch (e) {
      print('Report submission error: $e');
    }
    throw Exception('Failed to submit report');
  }

  // 4. POST /mobile/report/gps - Submit report with GPS
  Future<String> submitReportWithGPS({
    required String reporterName,
    required String reporterPhone,
    String? reporterEmail,
    String? cowTag,
    required String reportType,
    required String subject,
    required String message,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final url = '${ApiConfig.baseUrl}/mobile/report/gps';
      print('Submitting GPS report at: $url');
      
      final body = {
        'reporter_name': reporterName,
        'reporter_phone': reporterPhone,
        'report_type': reportType,
        'subject': subject,
        'message': message,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };
      
      if (reporterEmail != null) body['reporter_email'] = reporterEmail;
      if (cowTag != null) body['cow_tag'] = cowTag;
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      
      print('GPS report submission response status: ${response.statusCode}');
      print('GPS report submission response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['report_id']?.toString() ?? 'RPT${DateTime.now().millisecondsSinceEpoch}';
      }
    } catch (e) {
      print('GPS report submission error: $e');
    }
    throw Exception('Failed to submit GPS report');
  }

  // 5. GET /mobile/report/{report_id} - Get report status
  Future<Map<String, dynamic>?> getReportStatus(int reportId) async {
    try {
      final url = '${ApiConfig.baseUrl}/mobile/report/$reportId';
      print('Getting report status at: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('Report status response status: ${response.statusCode}');
      print('Report status response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Report status error: $e');
    }
    return null;
  }

  // 6. POST /mobile/verify/live - Live camera verification
  Future<CowModel?> verifyLive(String imagePath) async {
    try {
      final url = '${ApiConfig.baseUrl}/mobile/verify/live';
      print('Live verification at: $url');
      
      var request = http.MultipartRequest('POST', Uri.parse(url));
      var file = await http.MultipartFile.fromPath('file', imagePath);
      request.files.add(file);

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      
      print('Live verification response status: ${response.statusCode}');
      print('Live verification response body: $responseBody');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data['cow_found'] == true) {
          final cowData = data['cow_details'];
          return CowModel(
            id: cowData['cow_tag'] ?? '',
            name: 'Cow ${cowData['cow_tag'] ?? 'Unknown'}',
            age: cowData['age'] ?? 0,
            ownerName: cowData['owner_name'] ?? 'Unknown Owner',
            ownerEmail: cowData['owner_email'] ?? '',
            location: cowData['owner_address'] ?? '',
            state: '',
            witness: 'Live Camera Verified',
            noseImagePaths: [],
            registrationDate: DateTime.now(),
          );
        }
      }
    } catch (e) {
      print('Live verification error: $e');
    }
    return null;
  }

  // 7. GET /mobile/cow/{cow_tag}/face - Get cow face image
  Future<Map<String, dynamic>?> getCowFace(String cowTag) async {
    try {
      final url = '${ApiConfig.baseUrl}/mobile/cow/$cowTag/face';
      print('Getting cow face at: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('Cow face response status: ${response.statusCode}');
      print('Cow face response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Cow face error: $e');
    }
    return null;
  }

  // Legacy method - redirects to verifyByNose
  Future<CowModel?> verifyCow(List<String> imagePaths) async {
    return await verifyByNose(imagePaths);
  }

  // Legacy method - redirects to new submitReport
  Future<String> submitReportLegacy(Map<String, dynamic> reportData) async {
    return await submitReport(
      reporterName: reportData['reporter_name'] ?? '',
      reporterPhone: reportData['reporter_phone'] ?? '',
      reporterEmail: reportData['reporter_email'],
      cowTag: reportData['cow_tag'],
      reportType: reportData['type'] ?? reportData['report_type'] ?? '',
      subject: reportData['subject'] ?? reportData['type'] ?? '',
      message: reportData['description'] ?? reportData['message'] ?? '',
      location: reportData['location'],
    );
  }

  // Note: No mobile user settings endpoints available
  // Using local storage simulation
  Future<Map<String, dynamic>> getUserSettings(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return default settings since no mobile user settings endpoint exists
    return {
      'fontSize': 'medium',
      'notifications': true,
      'darkMode': false,
    };
  }

  // Update user settings (local simulation)
  Future<void> updateUserSettings(String userId, Map<String, dynamic> settings) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate settings update since no mobile endpoint exists
// Settings updated locally: $settings
  }

  // Delete user account (not available for mobile)
  Future<bool> deleteUserAccount(String userId) async {
    await Future.delayed(const Duration(seconds: 2));
    // Account deletion not available for mobile users
    return false;
  }
}