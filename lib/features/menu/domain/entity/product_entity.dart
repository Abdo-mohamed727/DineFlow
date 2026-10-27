class ProductsPageEntity {
  final List<ProductEntity> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const ProductsPageEntity({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  bool get hasNextPage => page < totalPages;
}

class ProductEntity {
  final String id;
  final String name;
  final String description;
  final int price;
  final String image;
  final String imagePublicId;
  final ProductCategoryEntity category;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.imagePublicId,
    required this.category,
    required this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });
}

class ProductCategoryEntity {
  final String id;
  final String name;

  const ProductCategoryEntity({required this.id, required this.name});
}