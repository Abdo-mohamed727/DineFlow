import 'package:dineflow/features/auth/domain/entity/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? phone;
  final String? photoUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.customer,
    this.phone,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.customer,
      ),
      phone: json['phone'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'phone': phone,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      phone: entity.phone,
      photoUrl: entity.photoUrl,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      role: role,
      phone: phone,
      photoUrl: photoUrl,
    );
  }
}
