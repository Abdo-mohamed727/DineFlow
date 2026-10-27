enum UserRole { customer, waiter, kitchen }

class UserEntity {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? phone;
  final String? profileImage;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.customer,
    this.phone,
    this.profileImage,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? phone,
    String? profileImage,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
