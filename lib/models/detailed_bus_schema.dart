import 'package:bus_finder_challenge/models/position.dart';

class DetailedBusSchema {
  final String originStopId;
  final String destinationStopId;
  final String destinationScheduledTime;
  final String destinationRealTime;
  final String busId;
  final String status;
  final int delaySecs;
  final Position position;

  DetailedBusSchema({
    required this.originStopId,
    required this.destinationStopId,
    required this.destinationScheduledTime,
    required this.destinationRealTime,
    required this.busId,
    required this.status,
    required this.delaySecs,
    required this.position,
  });

  factory DetailedBusSchema.fromJson(Map<String, dynamic> json) {
    return DetailedBusSchema(
      originStopId: json['origin_stop_id'],
      destinationStopId: json['destination_stop_id'],
      destinationScheduledTime: json['destination_scheduled_time'],
      destinationRealTime: json['destination_real_time'],
      busId: json['bus_id'],
      status: json['status'],
      delaySecs: json['delay_secs'],
      position: Position.fromJson(json['position']),
    );
  }
}
