import 'dart:isolate';
import 'package:finances/services/api_service.dart';
import 'package:finances/services/auth_service.dart';

class BudgetIsolateRequest {
  final Map<String, dynamic> body;
  final bool isUpdate;
  final SendPort sendPort;

  BudgetIsolateRequest(
      {required this.body, required this.isUpdate, required this.sendPort});
}

void budgetApiIsolate(BudgetIsolateRequest request) async {
  try {
    final token = await AuthService.instance.getIdToken();
    if (request.isUpdate) {
      await ApiService().updateBudget(token: token!, body: request.body);
    } else {
      await ApiService().postBudget(token: token!, body: request.body);
    }
    request.sendPort.send(true); // Success
  } catch (e) {
    print("❌ Isolate error: $e");
    request.sendPort.send(false); // Failure
  }
}
