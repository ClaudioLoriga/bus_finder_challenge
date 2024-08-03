import 'package:bus_finder_challenge/models/route_detail.dart';
import 'package:dio/dio.dart';

class BusLineDetailViewModel {
  final String? routeId;
  RouteDetail? _routeDetail;
  final Dio _dio = Dio();
  final String _apiUrl =
      'https://stage-bus-finder.greensharelab.com/api/v1/route_detail/';

  RouteDetail? get routeDetail => _routeDetail;

  BusLineDetailViewModel(this.routeId);

  Future<void> fetchRouteDetail() async {
    try {
      final response = await _dio.post(
        _apiUrl,
        data: {"route_id": routeId},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        _routeDetail = RouteDetail.fromJson(data);
      } else {
        throw Exception('Failed to load route detail');
      }
    } catch (e) {
      throw Exception('Error fetching bus lines: $e');
    }
  }
}
