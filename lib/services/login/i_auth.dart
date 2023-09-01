
abstract class IAuth{

  Future<String?> ReadToken();
  SaveToken(String token);
  DeleteToken();

}