import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheckService {
  static const String API_URL = 'https://api.life-lab.org/api/app-version';

  Future<void> checkAndPromptUpdate(BuildContext context) async {
    if (!context.mounted) {
      debugPrint("Context not ready for version check");
      return;
    }

    try {
      debugPrint("Starting version check...");

      // Get current version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion =
          "${packageInfo.version}+${packageInfo.buildNumber}";
      debugPrint("Current app version: $currentVersion");

      // Fetch latest version from API
      debugPrint("Fetching version from: $API_URL");
      final response = await http.get(Uri.parse(API_URL));
      debugPrint("API Response status code: ${response.statusCode}");
      debugPrint("API Response body: ${response.body}");

      if (response.statusCode == 200 && context.mounted) {
        final versionInfo = json.decode(response.body);
        final data = versionInfo['data'];

        final latestVersion = data['latest_version'].toString();
        final isForceUpdate = data['is_force_update'] as bool;
        final updateMessage = data['update_message'].toString();
        final storeUrl = Platform.isAndroid
            ? data['play_store_url'].toString()
            : data['app_store_url'].toString();

        debugPrint("Latest version: $latestVersion");
        debugPrint("Current version: $currentVersion");

        if (_shouldUpdate(currentVersion, latestVersion) && context.mounted) {
          await _showUpdateDialog(
            context,
            updateMessage,
            storeUrl,
            isForceUpdate,
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint("Error checking for updates: $e");
      debugPrint("Stack trace: $stackTrace");
    }
  }

  bool _shouldUpdate(String currentVersion, String latestVersion) {
    try {
      // Handle versions with and without build numbers
      String currentVersionOnly = currentVersion.split('+')[0];
      String latestVersionOnly = latestVersion.contains('+')
          ? latestVersion.split('+')[0]
          : latestVersion;

      List<int> current = currentVersionOnly
          .split('.')
          .map((e) => int.parse(e.trim()))
          .toList();
      List<int> latest =
          latestVersionOnly.split('.').map((e) => int.parse(e.trim())).toList();

      // Compare version numbers
      for (int i = 0; i < 3; i++) {
        if (latest[i] > current[i]) return true;
        if (latest[i] < current[i]) return false;
      }

      // Only compare build numbers if both versions have them
      if (currentVersion.contains('+') && latestVersion.contains('+')) {
        int currentBuild = int.parse(currentVersion.split('+')[1]);
        int latestBuild = int.parse(latestVersion.split('+')[1]);
        return latestBuild > currentBuild;
      }

      return false;
    } catch (e) {
      debugPrint("Error comparing versions: $e");
      return false;
    }
  }

  Future<void> _showUpdateDialog(
    BuildContext context,
    String message,
    String storeUrl,
    bool isForceUpdate,
  ) async {
    if (!context.mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: !isForceUpdate,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: !isForceUpdate,
          child: AlertDialog(
            title: const Text('Update Available'),
            content: Text(message),
            actions: [
              if (!isForceUpdate)
                TextButton(
                  child: const Text('Later'),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              TextButton(
                child: const Text('Update Now'),
                onPressed: () async {
                  final Uri url = Uri.parse(storeUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                    if (isForceUpdate && dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  } else {
                    debugPrint("Could not launch URL: $storeUrl");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
