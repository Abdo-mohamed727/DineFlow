import 'package:dineflow/features/menu/domain/entity/category_entity.dart';

 
class CategoriesResponseModel {
  final CategoriesDataModel? data;

  const CategoriesResponseModel({this.data});

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      data: json['data'] is Map<String, dynamic>
          ? CategoriesDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {'data': data?.toJson()};

  List<CategoryEntity> toEntity() =>
      data?.categories.map((e) => e.toEntity()).toList() ?? [];
}

class CategoriesDataModel {
  final List<CategoryModel> categories;

  const CategoriesDataModel({this.categories = const []});

  factory CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    return CategoriesDataModel(
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'categories': categories.map((e) => e.toJson()).toList(),
      };
}

class CategoryModel {
  final String? id;
  final String? name;
  final String? description;
  final String? image;
  final String? imagePublicId;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.imagePublicId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      imagePublicId: json['imagePublicId'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'imagePublicId': imagePublicId,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  CategoryEntity toEntity() => CategoryEntity(
        id: id ?? '',
        name: name ?? '',
        description: description ?? '',
        imageUrl: image ?? '',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}