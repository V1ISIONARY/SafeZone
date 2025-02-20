class CircleModel {
  final int id;
  final String name;
  final bool isActive;
  final String code;
  final String createdAt;

  CircleModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.code,
    required this.createdAt,
  });

  // Factory method to create CircleModel from JSON
  factory CircleModel.fromJson(Map<String, dynamic> json) {
    return CircleModel(
      id: json['id'],
      name: json['name'],
      code: json['code'] ?? "",
      isActive: json['is_active'],
      createdAt: json['created_at'],
    );
  }

  // Method to convert CircleModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'is_active': isActive,
      'created_at': createdAt,
    };
  }
}
