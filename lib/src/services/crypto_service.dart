import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:moto_tracking_flutter/src/services/storage_service.dart';

class CryptoService {
  static String sha256Hex(String value) {
    final bytes = utf8.encode(value);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 128 chars (2x SHA-256) like the web version
  static String generateImageHash({String? idIsu}) {
    final storage = StorageService();
    final isu = idIsu ?? storage.getString('id-isu') ?? '';
    final now = DateTime.now().toUtc();
    final dateString = now.toIso8601String();
    final timestamp = now.millisecondsSinceEpoch.toString();
    final combined = '$dateString$timestamp$isu';
    final hash1 = sha256Hex(combined);
    final hash2 = sha256Hex(combined + hash1);
    return hash1 + hash2;
  }
}
