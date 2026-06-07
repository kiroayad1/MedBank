import '../models/request_model.dart';
import 'request_repository.dart';

/// Mock implementation for offline development.
class RequestMockRepository implements RequestRepository {
  @override
  Future<List<RequestModel>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return RequestDummyData.requests;
  }

  @override
  Future<void> checkout(List<Map<String, int>> items) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

/// Offline mock data for requests
abstract final class RequestDummyData {
  static final List<RequestModel> requests = [
    RequestModel(
      id: 1,
      medicineName: 'Insulin Glargine',
      quantity: 3,
      status: 'Pending',
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RequestModel(
      id: 2,
      medicineName: 'Lisinopril',
      quantity: 1,
      status: 'Fulfilled',
      requestDate: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];
}
