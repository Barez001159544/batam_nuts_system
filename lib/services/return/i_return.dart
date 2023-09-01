import '../../models/pagnation_parameter.dart';
import '../../models/return_pagnation_response.dart';
import '../../models/return_response.dart';
import '../../return_heade_response.dart';

abstract class IReturnHeade{
  Future<ReturnHeadeResponse?> ReturnHeade(ReturnHeadeResponse returnHeadeResponse);
  Future<ReturnResponse?> Return(ReturnResponse returnResponse);
  Future<ReturnPagnationResponse?> ReturnPagnation(PagnationParameter pagnationParameter);
  Future<List<ReturnResponse>?> ReturnById(int id);
}