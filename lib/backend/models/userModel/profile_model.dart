class ProfileModel {
  final int id;
  final int userId;
  final String address;
  final bool isAdmin;
  final bool isGirl;
  final bool isVerified;
  final String status;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.address,
    required this.isAdmin,
    required this.isGirl,
    required this.isVerified,
    required this.status,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      address: json['address'] ?? 'Unknown',
      isAdmin: json['is_admin'] ?? false,
      isGirl: json['is_girl'] ?? false,
      isVerified: json['is_verified'] ?? false,
      status: json['status'] ?? "Safe", // Ensure correct key usage
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
      'status': status,
    };
  }
}
