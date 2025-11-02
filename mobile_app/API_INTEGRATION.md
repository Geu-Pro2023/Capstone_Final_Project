# API Integration Guide

## Overview
The Titweng mobile app has been updated to connect to the FastAPI backend deployed on Azure instead of using hardcoded mock data.

## Azure FastAPI Deployment
- **Production URL**: `https://titweng-app-a3hufygwcphxhkc2.canadacentral-01.azurewebsites.net`
- **Status**: Active and ready for mobile app integration

## API Endpoints Available

### Mobile Endpoints (Implemented)
- `POST /mobile/verify/nose` - Verify cattle by nose print images
- `GET /mobile/verify/tag/{cow_tag}` - Verify cattle by tag
- `POST /mobile/report` - Submit suspicious activity reports
- `POST /mobile/report/gps` - Submit reports with GPS coordinates
- `GET /mobile/report/{report_id}` - Get report status
- `POST /mobile/verify/live` - Live camera verification
- `GET /mobile/cow/{cow_tag}/face` - Get cow facial image by tag

### Admin Endpoints (Reference Only)
- `POST /admin/login` - Admin authentication
- `POST /admin/register-cow` - Register new cattle (admin only)
- `GET /admin/cows` - Get all registered cattle (admin only)

### Not Available for Mobile
- User authentication (handled by Firebase)
- User registration (handled by Firebase)
- Cattle registration (admin only)
- User settings management (local storage)

## Files Modified/Created

### New Files
1. **`lib/services/api_service.dart`** - Main API service for backend communication
2. **`lib/services/service_manager.dart`** - Service manager to switch between mock/API
3. **`lib/utils/api_config.dart`** - API configuration and endpoints
4. **`lib/screens/developer_settings.dart`** - Developer settings for testing

### Modified Files
1. **`lib/screens/main_dashboard.dart`** - Updated to use ServiceManager
2. **`lib/screens/verification_screen.dart`** - Updated to use ServiceManager
3. **`lib/screens/report_screen.dart`** - Updated to use ServiceManager

## Configuration

### Switching Between Mock and API
The app uses a `ServiceManager` that can switch between:
- **Mock Service**: Local testing with hardcoded data
- **API Service**: Real backend communication

To switch modes:
```dart
ServiceManager.setMode(ServiceMode.api);  // Use real API
ServiceManager.setMode(ServiceMode.mock); // Use mock data
```

### Environment Configuration
Edit `lib/utils/api_config.dart` to change API endpoints:

```dart
// Production (current)
static const String baseUrl = 'https://titweng-app-a3hufygwcphxhkc2.canadacentral-01.azurewebsites.net';

// Local development
// static const String baseUrl = 'http://localhost:8000';
```

## Features Implemented

### 1. User Authentication
- Firebase Auth integration (email/password, Google Sign-In)
- No backend authentication needed for mobile users

### 2. Cattle Verification ✅
- Upload multiple nose print images (up to 4)
- Real FastAPI ML processing via `/mobile/verify/nose`
- Display verification results with cow details
- Tag-based verification via `/mobile/verify/tag/{cow_tag}`

### 3. Report System ✅
- Submit reports via `/mobile/report`
- GPS-enabled reports via `/mobile/report/gps`
- Track report status via `/mobile/report/{report_id}`
- Generate report IDs for tracking

### 4. Cattle Registration
- Admin-only feature (mobile users cannot register cattle)
- Handled via admin dashboard

### 5. User Settings
- Local storage simulation (no backend endpoints for mobile)
- Firebase handles user profile management

## Error Handling
- Network timeout handling (30 seconds)
- Graceful fallback to mock data if API fails
- User-friendly error messages
- Retry mechanisms for failed requests

## Testing
1. **Mock Mode**: Test app functionality without backend
2. **API Mode**: Test with real Azure deployment
3. **Developer Settings**: Switch modes during development

## Next Steps
1. Test all API endpoints with the deployed FastAPI backend
2. Implement proper authentication tokens if needed
3. Add offline support for poor network conditions
4. Implement push notifications for report updates
5. Add analytics and monitoring

## Dependencies Added
- `http: ^1.1.0` - HTTP client for API calls (already in pubspec.yaml)

## Usage Example
```dart
// Using ServiceManager (recommended)
final cows = await ServiceManager.getAllCows();
final user = await ServiceManager.authenticateUser(email, password);

// Direct API service usage
final cows = await ApiService.instance.getAllCows();
```

The app is now ready to work with your deployed FastAPI backend on Azure!