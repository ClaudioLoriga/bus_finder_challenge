import 'dart:async';
import 'package:dio/dio.dart';
import '../models/line.dart';
import '../models/vehicle_id_schema.dart';

class BusLinesViewModel {
  final _busLinesController = StreamController<List<Line>>.broadcast();
  final Dio _dio = Dio();
  final String _apiUrl = 'https://stage-bus-finder.greensharelab.com/api/v1/real_time_lines/';

  Stream<List<Line>> get busLinesStream => _busLinesController.stream;

  BusLinesViewModel() {
    _loadBusLines();
  }

  Future<void> _loadBusLines() async {
    try {
      final response = await _dio.get(_apiUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final busLines = data.map((json) => Line.fromJson(json)).toList();
        _busLinesController.add(busLines);
      } else {
        throw Exception('Failed to load bus lines');
      }
    } catch (e) {
      _busLinesController.addError('Error fetching bus lines: $e');
    }
  }

  void dispose() {
    _busLinesController.close();
  }
}