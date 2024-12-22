class ContactsModel {
  final int id;
  final int userId;
  final String phoneNumber;
  final String email;

  ContactsModel({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.email,
  });

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    return ContactsModel(
      id: json['id'],
      userId: json['user_id'],
      phoneNumber: json['phone_number'].toString(),
      email: json['email'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'email': email,
    };
  }
}
