import '../models/request_model.dart';

/// Abstract interface for request data access.
abstract class RequestRepository {
  /// Fetch the current user's request history.
  Future<List<RequestModel>> getHistory();

  /// Checkout a list of medicine items.
  Future<void> checkout(List<Map<String, int>> items);
}
