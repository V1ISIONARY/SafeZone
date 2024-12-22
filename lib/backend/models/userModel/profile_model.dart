class ProfileModel {
  final int id;
  final int userId;
  final String address;
  final bool isAdmin;
  final bool isGirl;
  final bool isVerified;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.address,
    required this.isAdmin,
    required this.isGirl,
    required this.isVerified,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      address: json['address'],
      isAdmin: json['is_admin'] ?? false,
      isGirl: json['is_girl'] ?? false,
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'address': address,
      'is_admin': isAdmin,
      'is_girl': isGirl,
      'is_verified': isVerified,
    };
  }
}
