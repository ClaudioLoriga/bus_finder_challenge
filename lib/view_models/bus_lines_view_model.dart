import 'dart:async';
import 'package:dio/dio.dart';
import '../models/line.dart';
import '../utils/utils.dart';

class BusLinesViewModel {
  final _busLinesController = StreamController<List<Line>>.broadcast();
  final Dio _dio = Dio();

  Stream<List<Line>> get busLinesStream => _busLinesController.stream;

  BusLinesViewModel() {
    _loadBusLines();
  }

  Future<void> _loadBusLines() async {
    try {
      final response = await _dio.get(busLinesApiString);
      if (response.statusCode == succcessState) {
        final List<dynamic> data = response.data;
        final busLines = data.map((json) => Line.fromJson(json)).toList();
        _busLinesController.add(busLines);
      } else {
        throw Exception(busLinesLoadFail);
      }
    } catch (e) {
      _busLinesController.addError('$busLinesLoadFail $e');
    }
  }

  void dispose() {
    _busLinesController.close();
  }
}