class SafeZoneModel {
  int id;
  int? userId;
  bool? isVerified;
  double? latitude;
  double? longitude;
  double? radius;
  String? name;
  int? scale;
  String? description;
  String? timeOfDay;
  String? frequency;
  String? reportTimestamp;

  SafeZoneModel({
    required this.id,
    required this.isVerified,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.name,
    required this.scale,
    required this.description,
    required this.timeOfDay,
    required this.frequency,
    required this.reportTimestamp,
  });

  factory SafeZoneModel.fromJson(Map<String, dynamic> json) {
    return SafeZoneModel(
      id: json['id'],
      isVerified: json['is_verified'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      name: json['name'],
      scale: json['scale'],
      description: json['description'],
      timeOfDay: json['time_of_day'],
      frequency: json['frequency'],
      reportTimestamp: json['report_timestamp'],
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
      'scale': scale,
      'description': description,
      'time_of_day': timeOfDay,
      'frequency': frequency,
      'report_timestamp': reportTimestamp,
    };
  }
}
