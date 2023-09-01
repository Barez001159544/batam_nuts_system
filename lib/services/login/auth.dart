import 'package:bn_sl/services/login/i_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth implements IAuth{

  String _tokenKey='accessToken';
  final storage = new FlutterSecureStorage();

  @override
  DeleteToken() async {
    // TODO: implement DeleteToken
    await storage.delete(key: _tokenKey);
  }

  @override
  Future<String?> ReadToken() async {
    // TODO: implement ReadToken
    return await storage.read(key: _tokenKey);
  }

  @override
  SaveToken(String token) async {
    // TODO: implement SaveToken
    await storage.write(key: _tokenKey, value: token);
  }
}