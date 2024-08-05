import 'dart:async';
import '../utils/utils.dart';
import 'package:dio/dio.dart';
import '../models/route_detail.dart';

class BusLineDetailViewModel {
  final String? routeId;
  final _routeDetailController = StreamController<RouteDetail>.broadcast();
  final Dio _dio = Dio();

  Stream<RouteDetail> get routeDetailStream => _routeDetailController.stream;

  BusLineDetailViewModel(this.routeId) {
    loadRouteDetail();
  }

  Future<void> loadRouteDetail() async {
    try {
      final response = await _dio.post(
        routeDetailApiString,
        data: {routeIdJsonPlaceholder: routeId},
      );
      if (response.statusCode == succcessState) {
        final data = response.data;
        final routeDetail = RouteDetail.fromJson(data);
        _routeDetailController.add(routeDetail);
      } else {
        throw Exception(routeDetailLoadFail);
      }
    } catch (e) {
      _routeDetailController.addError('$routeDetailLoadFail $e');
    }
  }

  void dispose() {
    _routeDetailController.close();
  }
}