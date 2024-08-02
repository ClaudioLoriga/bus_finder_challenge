class TripGTFS {
  final String routeId;
  final String serviceId;
  final String tripId;
  final String? tripHeadsign;
  final int? directionId;
  final String? shapeId;

  TripGTFS({
    required this.routeId,
    required this.serviceId,
    required this.tripId,
    this.tripHeadsign,
    this.directionId,
    this.shapeId,
  });

  factory TripGTFS.fromJson(Map<String, dynamic> json) {
    return TripGTFS(
      routeId: json['route_id'],
      serviceId: json['service_id'],
      tripId: json['trip_id'],
      tripHeadsign: json['trip_headsign'],
      directionId: json['direction_id'],
      shapeId: json['shape_id'],
    );
  }
}
