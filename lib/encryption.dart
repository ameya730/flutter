import 'package:encrypt/encrypt.dart' as encrypt;

String myEncryptionDecryption(String text) {
  final key = encrypt.Key.fromUtf8(
      ')J@NcRfUjXn2r5u8)J@NcRfUjXn2r5u8'); //)J@NcRfUjXn2r5u8
  final iv = encrypt.IV.fromUtf8('AAAAAAAAAAAAAAAA');
  final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
  final encrypted = encrypter.encrypt(text, iv: iv);
  return encrypted.base64;
}
