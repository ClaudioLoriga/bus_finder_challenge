import 'trip_gtfs.dart';

class Line {
  final TripGTFS? trip;
  final String? startTime;
  final String? startDate;

  Line({
    this.trip,
    this.startTime,
    this.startDate,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      trip: json['trip'] != null ? TripGTFS.fromJson(json['trip']) : null,
      startTime: json['start_time'],
      startDate: json['start_date'],
    );
  }
}
