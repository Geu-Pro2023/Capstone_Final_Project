import 'package:flutter/material.dart';
import 'package:titweng/utils/app_theme.dart';
import 'package:titweng/services/service_manager.dart';

class DeveloperSettings extends StatefulWidget {
  const DeveloperSettings({super.key});

  @override
  State<DeveloperSettings> createState() => _DeveloperSettingsState();
}

class _DeveloperSettingsState extends State<DeveloperSettings> {
  ServiceMode _currentMode = ServiceManager.currentMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Settings'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile<ServiceMode>(
              title: const Text('Mock Service'),
              subtitle: const Text('Use local mock data for testing'),
              value: ServiceMode.mock,
              groupValue: _currentMode,
              onChanged: (ServiceMode? value) {
                if (value != null) {
                  setState(() {
                    _currentMode = value;
                    ServiceManager.setMode(value);
                  });
                }
              },
            ),
            RadioListTile<ServiceMode>(
              title: const Text('API Service'),
              subtitle: const Text('Use real FastAPI backend'),
              value: ServiceMode.api,
              groupValue: _currentMode,
              onChanged: (ServiceMode? value) {
                if (value != null) {
                  setState(() {
                    _currentMode = value;
                    ServiceManager.setMode(value);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}