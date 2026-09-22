import 'package:dineflow/features/menu/domain/entity/product_entity.dart';

class ProductsModel {
  Data? data;

  ProductsModel({this.data});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

  ProductsPageEntity toEntity() => (data ?? Data()).toEntity();
}

class Data {
  List<Items>? items;
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Data({this.items, this.total, this.page, this.limit, this.totalPages});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items!.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    map['totalPages'] = totalPages;
    return map;
  }

  ProductsPageEntity toEntity() => ProductsPageEntity(
        items: items?.map((e) => e.toEntity()).toList() ?? [],
        total: total ?? 0,
        page: page ?? 1,
        limit: limit ?? 0,
        totalPages: totalPages ?? 0,
      );
}

class Items {
  String? id;
  String? name;
  String? description;
  int? price;
  String? image;
  String? imagePublicId;
  CategoryId? categoryId;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;

  Items({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.imagePublicId,
    this.categoryId,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? json['_id']?.toString();
    name = json['name']?.toString() ??
        json['title']?.toString() ??
        json['productName']?.toString();
    description = json['description']?.toString() ?? json['desc']?.toString();
    price = _asInt(json['price'] ?? json['unitPrice']);
    image = json['image']?.toString() ??
        json['imageUrl']?.toString() ??
        json['img']?.toString();
    imagePublicId = json['imagePublicId']?.toString();
    
    final cat = json['category'] ?? json['categoryId'];
    if (cat is Map<String, dynamic>) {
      categoryId = CategoryId.fromJson(cat);
    } else if (cat is Map) {
      categoryId = CategoryId.fromJson(Map<String, dynamic>.from(cat));
    } else if (cat is String) {
      categoryId = CategoryId(id: cat, name: cat);
    }

    isAvailable = json['isAvailable'] as bool? ?? true;
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['price'] = price;
    map['image'] = image;
    map['imagePublicId'] = imagePublicId;
    if (categoryId != null) {
      map['categoryId'] = categoryId!.toJson();
    }
    map['isAvailable'] = isAvailable;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

  ProductEntity toEntity() => ProductEntity(
        id: id ?? '',
        name: name ?? '',
        description: description ?? '',
        price: price ?? 0,
        image: image ?? '',
        imagePublicId: imagePublicId ?? '',
        category: (categoryId ?? CategoryId()).toEntity(),
        isAvailable: isAvailable ?? false,
        createdAt: DateTime.tryParse(createdAt ?? ''),
        updatedAt: DateTime.tryParse(updatedAt ?? ''),
      );
}

class CategoryId {
  String? id;
  String? name;

  CategoryId({this.id, this.name});

  CategoryId.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? json['_id']?.toString();
    name = json['name']?.toString() ?? json['title']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

  ProductCategoryEntity toEntity() => ProductCategoryEntity(
        id: id ?? '',
        name: name ?? '',
      );
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  return int.tryParse(value.toString()) ??
      double.tryParse(value.toString())?.round();
}