import '../../../../core/network/services/request_service.dart';
import '../models/request_model.dart';
import 'request_repository.dart';

/// Real implementation that calls the backend API.
class RequestApiRepository implements RequestRepository {
  @override
  Future<List<RequestModel>> getHistory() async {
    final res = await RequestService.instance.getHistory();
    return res.map((json) => RequestModel.fromJson(json)).toList();
  }

  @override
  Future<void> checkout(List<Map<String, int>> items) async {
    await RequestService.instance.checkout(items);
  }
}
