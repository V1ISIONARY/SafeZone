class CircleModel {
  final int id;
  final String name;
  bool isActive;
  final String code;
  String? createdAt;
  final String codeExpiry; // Added code expiry

  CircleModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.code,
    this.createdAt,
    required this.codeExpiry, // Added code expiry
  });

  // Factory method to create CircleModel from JSON
  factory CircleModel.fromJson(Map<String, dynamic> json) {
    return CircleModel(
      id: json['circle_id'] ?? 0,
      name: json['circle_name'],
      code: json['code'] ?? "",
      isActive: json['status'],
      createdAt: json['created_at'] ?? "",
      codeExpiry: json['code_expiry'] ?? "", // Map expiry time
    );
  }

  // Method to convert CircleModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'circle_id': id,
      'circle_name': name,
      'code': code,
      'is_active': isActive,
      'created_at': createdAt,
      'code_expiry': codeExpiry, // Add expiry time to JSON
    };
  }
}
