import 'dart:convert';
import 'package:crypto/crypto.dart';

class FFHashing {
  static int hashString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    
    // Take first 8 bytes for a 64-bit-like integer value
    final hashInt = digest.bytes.take(8).fold<int>(0, (prev, element) => (prev << 8) | element);
    
    return hashInt.abs();
  }
}
