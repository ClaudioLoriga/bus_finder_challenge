class Position {
  double latitude;
  double longitude;

  Position({required this.latitude, required this.longitude});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      latitude: json['lat'],
      longitude: json['lon'],
    );
  }
}
