import 'dart:async';
import 'package:dio/dio.dart';
import '../model/bus_line.dart';

class BusLinesViewModel {
  final _busLinesController = StreamController<List<BusLine>>.broadcast();
  final Dio _dio = Dio();
  final String _apiUrl = 'https://stage-bus-finder.greensharelab.com/api/v1/bus_list/';

  Stream<List<BusLine>> get busLinesStream => _busLinesController.stream;

  BusLinesViewModel() {
    _loadBusLines();
  }

  Future<void> _loadBusLines() async {
    try {
      final response = await _dio.get(_apiUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final busLines = data.map((json) => BusLine(
          json['vehicle_id'],
          json['vehicle_label'],
          json['is_active']
        )).toList();
        _busLinesController.add(busLines);
      } else {
        throw Exception('Failed to load bus stops');
      }
    } catch (e) {
      _busLinesController.addError('Error fetching bus stops: $e');
    }
  }

  void dispose() {
    _busLinesController.close();
  }
}