import 'detailed_bus_schema.dart';
import 'detailed_stop_schema.dart';

class Direction {
  final String departureCapolineaId;
  final String destinationCapolineaId;
  final String headsignId;
  final int direction;
  final List<DetailedBusSchema> busList;
  final List<DetailedStopSchema> stops;
  final String shape;

  Direction({
    required this.departureCapolineaId,
    required this.destinationCapolineaId,
    required this.headsignId,
    required this.direction,
    required this.busList,
    required this.stops,
    required this.shape,
  });

  factory Direction.fromJson(Map<String, dynamic> json) {
    return Direction(
      departureCapolineaId: json['departure_capolinea_id'],
      destinationCapolineaId: json['destination_capolinea_id'],
      headsignId: json['headsign_id'],
      direction: json['direction'],
      busList: List<DetailedBusSchema>.from(json['bus_list'].map((x) => DetailedBusSchema.fromJson(x))),
      stops: List<DetailedStopSchema>.from(json['stops'].map((x) => DetailedStopSchema.fromJson(x))),
      shape: json['shape'],
    );
  }
}