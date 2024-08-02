import 'direction.dart';

class RouteDetail {
  final String routeId;
  final String routeName;
  final String routeColor;
  final Map<String, Direction> directions;

  RouteDetail({
    required this.routeId,
    required this.routeName,
    required this.routeColor,
    required this.directions,
  });

  factory RouteDetail.fromJson(Map<String, dynamic> json) {
    var routeData = json['route'];
    var directionsMap = <String, Direction>{};
    routeData['directions'].forEach((key, value) {
      directionsMap[key] = Direction.fromJson(value);
    });

    return RouteDetail(
      routeId: routeData['route_id'],
      routeName: routeData['route_name'],
      routeColor: routeData['route_color'],
      directions: directionsMap,
    );
  }
}