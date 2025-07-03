import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../features/User/Model/user_account_model.dart';
import '../../Network/serves_locator.dart';
import 'app_data_utils.dart';

class AppDataExport {
  /// Export data to an encrypted JSON file
  static Future<void> exportData(String fileName) async {
    try {
      final userBox = getIt<Box<UserAccountModel>>();

      // Convert Hive box data to JSON-compatible Map
      final data = {
        'userAccountBox': _convertBoxToMap(userBox),
        // Add other boxes as needed, e.g.,
        // 'taskBox': _convertBoxToMap(taskBox),
        // 'categoryBox': _convertBoxToMap(categoryBox),
        // 'priorityBox': _convertBoxToMap(priorityBox),
      };

      // Encode to JSON string
      final jsonString = jsonEncode(data);

      // Encrypt the JSON string
      final encryptedData = AppDataUtils.encryptData(jsonString);

      // Define export path
      final downloadsDirectory = Directory('/storage/emulated/0/Download/UpTodo');
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }

      // Save the encrypted data to a file
      final file = File('${downloadsDirectory.path}/$fileName');
      await file.writeAsString(encryptedData);

      log('Backup saved at ${file.path}');
    } catch (e) {
      log('Error during export: $e');
      throw Exception('Failed to export data.');
    }
  }

  /// Converts a Hive box to a JSON-compatible map
  static Map<String, dynamic> _convertBoxToMap(Box box) {
    return box.toMap().map((key, value) {
      if (value is UserAccountModel) {
        return MapEntry(key.toString(), value.toJson()); // Ensure toJson is implemented
      }
      return MapEntry(key.toString(), value);
    });
  }
}
