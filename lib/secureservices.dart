import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _secureStorage = FlutterSecureStorage();

  Future writePassWord(String value) async {
    await _secureStorage.write(key: 'password', value: value);
  }

  Future readPassword() async {
    var passWord = await _secureStorage.read(key: 'password');
    return passWord;
  }

  Future writeUserName(String value) async {
    await _secureStorage.write(key: 'userName', value: value);
  }

  Future readUserName() async {
    var userName = await _secureStorage.read(key: 'userName');
    return userName;
  }

  Future removeAllSecureDetails() async {
    await _secureStorage.delete(key: 'password');
    await _secureStorage.delete(key: 'userName');
    print('All details have been deleted');
  }
}
