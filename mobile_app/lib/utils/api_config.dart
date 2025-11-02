class ApiConfig {
  // Production API URL (Azure deployment)
  static const String baseUrl = 'https://titweng-app-a3hufygwcphxhkc2.canadacentral-01.azurewebsites.net';
  
  // Development/Local API URL (uncomment for local testing)
  // static const String baseUrl = 'http://localhost:8000';
  
  // Mobile API Endpoints (actual FastAPI endpoints)
  static const String mobileVerifyNose = '/mobile/verify/nose';
  static const String mobileVerifyTag = '/mobile/verify/tag';
  static const String mobileReport = '/mobile/report';
  static const String mobileReportGps = '/mobile/report/gps';
  static const String mobileReportStatus = '/mobile/report';
  static const String mobileVerifyLive = '/mobile/verify/live';
  static const String mobileCowFace = '/mobile/cow';
  
  // Admin endpoints (for reference)
  static const String adminLogin = '/admin/login';
  static const String adminRegisterCow = '/admin/register-cow';
  static const String adminCows = '/admin/cows';
  
  // Request timeout
  static const Duration timeout = Duration(seconds: 30);
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}