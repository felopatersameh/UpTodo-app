import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_data_utils.dart';
import 'package:file_picker/file_picker.dart';

class AppDataImport {
  /// Import data from an encrypted JSON file
  static Future<void> importData(File file) async {
    try {
      // Read and decrypt the file
      final encryptedData = await file.readAsString();
      final jsonString = AppDataUtils.decryptData(encryptedData);

      // Decode JSON data
      final data = jsonDecode(jsonString);

      // Open Hive boxes
      final userBox = await Hive.openBox('userAccountBox');
      // final taskBox = await Hive.openBox('taskBox');
      // final categoryBox = await Hive.openBox('categoryBox');
      // final priorityBox = await Hive.openBox('priorityBox');

      // Restore data to respective boxes if valid
      if (data['userAccountBox'] is Map) {
        await userBox.putAll(Map<String, dynamic>.from(data['userAccountBox']));
      }
      // if (data['taskBox'] is Map) {
      //   await taskBox.putAll(Map<String, dynamic>.from(data['taskBox']));
      // }
      // if (data['categoryBox'] is Map) {
      //   await categoryBox.putAll(Map<String, dynamic>.from(data['categoryBox']));
      // }
      // if (data['priorityBox'] is Map) {
      //   await priorityBox.putAll(Map<String, dynamic>.from(data['priorityBox']));
      // }

    } catch (e) {
      // Log the error for debugging
      throw Exception('Failed to import data.');
    }
  }

  /// Restore data by picking a file using File Picker
  Future<void> restoreData() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        await AppDataImport.importData(file);
      } else {
      }
    } catch (e) {
      throw Exception('Failed to restore data.');
    }
  }
}
