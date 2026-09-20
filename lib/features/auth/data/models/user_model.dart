import 'package:dineflow/features/auth/domain/entity/user_entity.dart';

class UsersModel {
  Data? data;

  UsersModel({this.data});

  UsersModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data'] as Map<String, dynamic>) : null;
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

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null;
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

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
    role = json['role'] as String?;
    profileImage = json['profileImage'] as String?;
    profileImagePublicId = json['profileImagePublicId'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
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
        (r) => r.name == role,
        orElse: () => UserRole.customer,
      ),
      phone: phone,
      profileImage: profileImage,
    );
  }
}
