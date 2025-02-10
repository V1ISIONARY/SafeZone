class SafeZoneModel {
  int? id;
  int? userId;
  bool? isVerified;
  double? latitude;
  double? longitude;
  double? radius;
  String? name;
  double? scale;
  String? description;
  String? timeOfDay;
  String? frequency;
  String? status;
  String? reportTimestamp;

  SafeZoneModel({
    this.id,
    this.userId,
    this.isVerified,
    this.latitude,
    this.longitude,
    this.radius,
    this.name,
    this.scale,
    this.description,
    this.timeOfDay,
    this.frequency,
    this.status,
    this.reportTimestamp,
  });

  factory SafeZoneModel.fromJson(Map<String, dynamic> json) {
    return SafeZoneModel(
      id: json['id'],
      userId: json['user_id'],
      isVerified: json['is_verified'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      name: json['name'],
      scale: json['scale'],
      description: json['description'],
      timeOfDay: json['time_of_day'],
      frequency: json['frequency'],
      status: json['status'],
      reportTimestamp: json['report_timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'is_verified': isVerified,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'name': name,
      'scale': scale,
      'description': description,
      'time_of_day': timeOfDay,
      'frequency': frequency,
      'status': status,
      'report_timestamp': reportTimestamp,
    };
  }
}
