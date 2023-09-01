import '../../models/general_response.dart';

abstract class IGeneral{
  //
  Future<List<GeneralResponse>?> Get();
  Future<List<GeneralResponse>?> Put(GeneralResponse generalResponse);
}