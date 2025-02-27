class ProfileModel {
  final int id;
  final int userId;
  final String address;
  final bool isAdmin;
  final bool isGirl;
  final bool isVerified;
  final String status;
  final int? circleId;
  final String profilePicture;
  final String phoneNumber;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.address,
    required this.isAdmin,
    required this.isGirl,
    required this.isVerified,
    required this.status,
    required this.circleId,
    required this.profilePicture,
    required this.phoneNumber,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      address: json['address'] ?? 'Unknown',
      isAdmin: json['is_admin'] ?? false,
      isGirl: json['is_girl'] ?? false,
      isVerified: json['is_verified'] ?? false,
      status: json['status'] ?? "Safe",
      circleId: json['active_circle'] ?? 0,
      profilePicture: json['profile_picture'] ?? "Safe",
      phoneNumber: json['phone_number'] ?? "Safe",
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
      'active_circle': circleId,
      'profile_picture': profilePicture,
      'phone_number': phoneNumber,
    };
  }
}
