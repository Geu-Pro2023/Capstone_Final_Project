import 'package:titweng/models/cow_model.dart';
import 'package:titweng/models/user_model.dart';
import 'package:titweng/services/api_service.dart';
import 'package:titweng/services/mock_service.dart';

enum ServiceMode { mock, api }

class ServiceManager {
  static ServiceMode _currentMode = ServiceMode.api; // Default to API
  
  static ServiceMode get currentMode => _currentMode;
  
  static void setMode(ServiceMode mode) {
    _currentMode = mode;
  }
  
  // Authentication
  static Future<UserModel?> authenticateUser(String email, String password) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.authenticateUser(email, password);
      case ServiceMode.api:
        return await ApiService.instance.authenticateUser(email, password);
    }
  }

  // User registration
  static Future<UserModel?> createUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.createUser(
          fullName: fullName,
          email: email,
          password: password,
          phone: phone,
        );
      case ServiceMode.api:
        return await ApiService.instance.createUser(
          fullName: fullName,
          email: email,
          password: password,
          phone: phone,
        );
    }
  }

  // Cow registration
  static Future<void> registerCow(CowModel cow) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.registerCow(cow);
      case ServiceMode.api:
        return await ApiService.instance.registerCow(cow);
    }
  }

  // Get all cows
  static Future<List<CowModel>> getAllCows() async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.getAllCows();
      case ServiceMode.api:
        return await ApiService.instance.getAllCows();
    }
  }

  // Cow verification by nose print
  static Future<CowModel?> verifyCow(List<String> imagePaths) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.verifyCow(imagePaths);
      case ServiceMode.api:
        return await ApiService.instance.verifyByNose(imagePaths);
    }
  }

  // Live camera verification
  static Future<CowModel?> verifyLive(String imagePath) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.verifyCow([imagePath]);
      case ServiceMode.api:
        return await ApiService.instance.verifyLive(imagePath);
    }
  }

  // Get cow face image
  static Future<Map<String, dynamic>?> getCowFace(String cowTag) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return {'image_url': 'mock_image.jpg', 'cow_details': {}};
      case ServiceMode.api:
        return await ApiService.instance.getCowFace(cowTag);
    }
  }

  // Cow verification by tag
  static Future<CowModel?> verifyByTag(String cowTag) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        // Mock service doesn't have verifyByTag, use verifyCow with empty list
        return await MockService.instance.verifyCow([]);
      case ServiceMode.api:
        return await ApiService.instance.verifyByTag(cowTag);
    }
  }

  // Submit report
  static Future<String> submitReport(Map<String, dynamic> reportData) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.submitReport(reportData);
      case ServiceMode.api:
        return await ApiService.instance.submitReportLegacy(reportData);
    }
  }

  // Submit report with proper fields
  static Future<String> submitReportNew({
    required String reporterName,
    required String reporterPhone,
    String? reporterEmail,
    String? cowTag,
    required String reportType,
    required String subject,
    required String message,
    String? location,
  }) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.submitReport({
          'reporter_name': reporterName,
          'reporter_phone': reporterPhone,
          'reporter_email': reporterEmail,
          'cow_tag': cowTag,
          'report_type': reportType,
          'subject': subject,
          'message': message,
          'location': location,
        });
      case ServiceMode.api:
        return await ApiService.instance.submitReport(
          reporterName: reporterName,
          reporterPhone: reporterPhone,
          reporterEmail: reporterEmail,
          cowTag: cowTag,
          reportType: reportType,
          subject: subject,
          message: message,
          location: location,
        );
    }
  }

  // Submit report with GPS
  static Future<String> submitReportWithGPS({
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
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.submitReport({
          'reporter_name': reporterName,
          'reporter_phone': reporterPhone,
          'reporter_email': reporterEmail,
          'cow_tag': cowTag,
          'report_type': reportType,
          'subject': subject,
          'message': message,
          'latitude': latitude,
          'longitude': longitude,
        });
      case ServiceMode.api:
        return await ApiService.instance.submitReportWithGPS(
          reporterName: reporterName,
          reporterPhone: reporterPhone,
          reporterEmail: reporterEmail,
          cowTag: cowTag,
          reportType: reportType,
          subject: subject,
          message: message,
          latitude: latitude,
          longitude: longitude,
        );
    }
  }

  // Get report status
  static Future<Map<String, dynamic>?> getReportStatus(int reportId) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return {'status': 'pending', 'report_id': reportId};
      case ServiceMode.api:
        return await ApiService.instance.getReportStatus(reportId);
    }
  }

  // Get user settings
  static Future<Map<String, dynamic>> getUserSettings(String userId) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return MockService.instance.getUserSettings();
      case ServiceMode.api:
        return await ApiService.instance.getUserSettings(userId);
    }
  }

  // Update user settings
  static Future<void> updateUserSettings(String userId, Map<String, dynamic> settings) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.updateUserSettings(settings);
      case ServiceMode.api:
        return await ApiService.instance.updateUserSettings(userId, settings);
    }
  }

  // Delete user account
  static Future<bool> deleteUserAccount(String userId) async {
    switch (_currentMode) {
      case ServiceMode.mock:
        return await MockService.instance.deleteUserAccount(userId);
      case ServiceMode.api:
        return await ApiService.instance.deleteUserAccount(userId);
    }
  }
}