class CircleModel {
  final int id;
  final int userId;

  CircleModel({
    required this.id,
    // 
    required this.userId,
  });

  factory CircleModel.fromJson(Map<String, dynamic> json) {
    return CircleModel(
      id: json['id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
    };
  }
}
