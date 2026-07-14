class UserModel {
  final int id;
  final String name;
  final String email;
  final String department;
  final String mobile;
  final String companyName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.mobile,
    required this.companyName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      department: json['company']?['bs'] ?? 'General',
      mobile: json['phone'] ?? '',
      companyName: json['company']?['name'] ?? 'Company Inc.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'mobile': mobile,
      'companyName': companyName,
    };
  }
}
