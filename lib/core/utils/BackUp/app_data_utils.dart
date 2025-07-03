import 'dart:convert';
import 'package:crypto/crypto.dart';

class AppDataUtils {
  static const String _encryptionKey = 'secure_key_123456789'; // Encryption Key

  /// Text Encryption
  static String encryptData(String data) {
    final key = utf8.encode(_encryptionKey);
    final bytes = utf8.encode(data);

    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);

    return base64Encode(utf8.encode('$digest:$data'));
  }

  /// Decoding Texts
  static String decryptData(String encryptedData) {
    final decoded = utf8.decode(base64Decode(encryptedData));
    final parts = decoded.split(':');
    if (parts.length != 2) throw FormatException('Invalid encrypted format');

    final hash = parts[0];
    final data = parts[1];

    final key = utf8.encode(_encryptionKey);
    final bytes = utf8.encode(data);

    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes).toString();

    if (digest != hash) {
      throw FormatException('Data integrity check failed');
    }

    return data;
  }

}
