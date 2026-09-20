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
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    imagePublicId = json['imagePublicId'];
    categoryId = json['categoryId'] != null
        ? CategoryId.fromJson(json['categoryId'])
        : null;
    isAvailable = json['isAvailable'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    id = json['id'];
    name = json['name'];
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