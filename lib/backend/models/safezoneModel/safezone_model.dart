class SafeZoneModel {
  final int id;
  final bool isVerified;
  final double latitude;
  final double longitude;
  final double radius;
  final String name;

  SafeZoneModel({
    required this.id,
    required this.isVerified,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.name,
  });

  factory SafeZoneModel.fromJson(Map<String, dynamic> json) {
    return SafeZoneModel(
      id: json['id'],
      isVerified: json['is_verified'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_verified': isVerified,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'name': name,
    };
  }
}
