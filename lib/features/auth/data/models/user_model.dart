import 'package:dineflow/features/auth/domain/entity/user_entity.dart';

class UsersModel {
  Data? data;

  UsersModel({this.data});

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      data: json['data'] != null
          ? Data.fromJson(json['data'] as Map<String, dynamic>)
          : Data(user: User.fromJson(json)),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

  UserEntity toEntity() => (data?.user ?? User()).toEntity();
}

class Data {
  User? user;

  Data({this.user});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : User.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? role;
  String? profileImage;
  String? profileImagePublicId;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.profileImage,
    this.profileImagePublicId,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final target = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : (json['data'] is Map<String, dynamic> &&
                json['data']['user'] is Map<String, dynamic>
            ? json['data']['user'] as Map<String, dynamic>
            : (json['data'] is Map<String, dynamic>
                ? json['data'] as Map<String, dynamic>
                : json));

    return User(
      id: (target['id'] ?? target['_id'])?.toString(),
      name: target['name'] as String?,
      email: target['email'] as String?,
      phone: target['phone'] as String?,
      role: target['role'] as String?,
      profileImage: (target['profileImage'] ??
          target['profile_image'] ??
          target['photoUrl'] ??
          target['avatar']) as String?,
      profileImagePublicId: target['profileImagePublicId'] as String?,
      createdAt: (target['createdAt'] ?? target['created_at'])?.toString(),
      updatedAt: (target['updatedAt'] ?? target['updated_at'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['role'] = role;
    map['profileImage'] = profileImage;
    map['profileImagePublicId'] = profileImagePublicId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id ?? '',
      name: name ?? '',
      email: email ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name.toLowerCase() == (role ?? '').toLowerCase(),
        orElse: () => UserRole.customer,
      ),
      phone: phone,
      profileImage: profileImage,
    );
  }
}
