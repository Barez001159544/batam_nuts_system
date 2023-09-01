import 'package:bn_sl/models/pagnation_parameter.dart';

import '../models/return_invoice_pagination.dart';

abstract class IInvoice{
  Future<ReturnInvoicePagination?> GetPagination(PagnationParameter pagnationParameter);
}