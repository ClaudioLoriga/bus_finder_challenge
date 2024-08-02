class VehicleIdSchema {
  String id;
  String label;
  bool isActive;

  VehicleIdSchema(
      {required this.id, required this.label, required this.isActive});

  factory VehicleIdSchema.fromJson(Map<String, dynamic> json) {
    return VehicleIdSchema(
      id: json['vehicle_id'],
      label: json['vehicle_label'],
      isActive: json['is_active'],
    );
  }
}
