import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../configuration.dart';

class DatabaseExporter {
  static Future exportAndroid() async {
    var downloadsPath = await _getAndroidDownloadsDirectoryPath();

    var databaseFileName = Configuration.databaseFileName;
    var databaseFilePath = join(await getDatabasesPath(), databaseFileName);
    var databaseFile = File(databaseFilePath);
    var databaseFileBytes = databaseFile.readAsBytesSync();
    var bytes = ByteData.view(databaseFileBytes.buffer);
    final buffer = bytes.buffer;

    var filePath = downloadsPath + '/exported-$databaseFileName';
    File(filePath).writeAsBytes(buffer.asUint8List(
        databaseFileBytes.offsetInBytes, databaseFileBytes.lengthInBytes));
  }

  static Future<String> _getAndroidDownloadsDirectoryPath() async {
    // See also: spending\android\app\src\main\kotlin\kj\spending\spending\MainActivity.kt
    const platform = MethodChannel('com.example/downloads');

    return await platform.invokeMethod('getDownloadsPath');
  }
}