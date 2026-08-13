enum UserRole { customer, waiter, kitchen }

class UserEntity {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? phone;
  final String? photoUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.customer,
    this.phone,
    this.photoUrl,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? phone,
    String? photoUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
