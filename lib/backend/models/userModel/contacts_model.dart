class ContactsModel {
  final int id;
  final int userId;
  final String phoneNumber;
  final String name;

  ContactsModel({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.name,
  });

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    return ContactsModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      phoneNumber: json['phone_number'].toString(),
      name: json['name'] ?? "",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'name': name,
    };
  }
}
