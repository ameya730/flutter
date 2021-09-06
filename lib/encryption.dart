import 'package:encrypt/encrypt.dart' as encrypt;

String myEncryptionDecryption(String text) {
  final key = encrypt.Key.fromUtf8(')J@NcRfUjXn2r5u8');
  print(key.base64);
  final iv = encrypt.IV.fromLength(16);
  print(iv.base64);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encrypt(text, iv: iv);
  return encrypted.base64;
}
