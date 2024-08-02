import 'package:bus_finder_challenge/models/position.dart';

class DetailedStopSchema {
  final bool capolinea;
  final String stopId;
  final String stopCode;
  final String stopName;
  final int stopSequence;
  final Position position;

  DetailedStopSchema({
    required this.capolinea,
    required this.stopId,
    required this.stopCode,
    required this.stopName,
    required this.stopSequence,
    required this.position,
  });

  factory DetailedStopSchema.fromJson(Map<String, dynamic> json) {
    return DetailedStopSchema(
      capolinea: json['capolinea'],
      stopId: json['stop_id'],
      stopCode: json['stop_code'],
      stopName: json['stop_name'],
      stopSequence: json['stop_sequence'],
      position: Position.fromJson(json['position']),
    );
  }
}