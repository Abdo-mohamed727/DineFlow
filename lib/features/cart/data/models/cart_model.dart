import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:dineflow/features/menu/data/models/product_model.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';

class CartItemModel {
  String? productId;
  int? quantity;
  Items? product;
  int? lineTotal;

  CartItemModel({
    this.productId,
    this.quantity,
    this.product,
    this.lineTotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? productMap;
    String? parsedProductId;

    final rawProductId = json['productId'];
    final rawProduct = json['product'] ?? json['item'];

    if (rawProduct is Map<String, dynamic>) {
      productMap = rawProduct;
      parsedProductId = productMap['id']?.toString() ??
          productMap['_id']?.toString() ??
          (rawProductId is String ? rawProductId : null);
    } else if (rawProduct is Map) {
      productMap = Map<String, dynamic>.from(rawProduct);
      parsedProductId = productMap['id']?.toString() ??
          productMap['_id']?.toString() ??
          (rawProductId is String ? rawProductId : null);
    } else if (rawProductId is Map<String, dynamic>) {
      productMap = rawProductId;
      parsedProductId =
          productMap['id']?.toString() ?? productMap['_id']?.toString();
    } else if (rawProductId is Map) {
      productMap = Map<String, dynamic>.from(rawProductId);
      parsedProductId =
          productMap['id']?.toString() ?? productMap['_id']?.toString();
    } else {
      if (rawProductId != null) {
        parsedProductId = rawProductId.toString();
      }
      if (json.containsKey('name') ||
          json.containsKey('productName') ||
          json.containsKey('title') ||
          json.containsKey('price')) {
        productMap = json;
      }
    }

    Items? product;
    if (productMap != null) {
      product = Items.fromJson(productMap);
      parsedProductId ??= product.id;
    }

    final quantity = _asInt(json['quantity']) ?? 1;
    final unitPrice = _asInt(json['price']) ??
        _asInt(json['unitPrice']) ??
        product?.price ??
        0;
    final lineTotal = _asInt(json['lineTotal']) ??
        _asInt(json['total']) ??
        (unitPrice * quantity);

    return CartItemModel(
      productId: parsedProductId ?? product?.id,
      quantity: quantity,
      product: product,
      lineTotal: lineTotal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      if (product != null) 'product': product!.toJson(),
      'lineTotal': lineTotal,
    };
  }

  CartItemEntity toEntity() {
    final mappedProduct = product?.toEntity() ??
        ProductEntity(
          id: productId ?? '',
          name: '',
          description: '',
          price: 0,
          image: '',
          imagePublicId: '',
          category: const ProductCategoryEntity(id: '', name: ''),
          isAvailable: true,
        );

    final qty = quantity ?? 1;
    final calculatedTotal = lineTotal ??
        ((mappedProduct.price > 0 ? mappedProduct.price : 0) * qty);

    return CartItemEntity(
      productId: productId ?? mappedProduct.id,
      quantity: qty,
      product: mappedProduct,
      lineTotal: calculatedTotal,
    );
  }
}

class CartModel {
  String? id;
  List<CartItemModel>? items;
  int? subtotal;
  int? tax;
  int? total;

  CartModel({
    this.id,
    this.items,
    this.subtotal,
    this.tax,
    this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final payload = _unwrapCartJson(json);
    final rawItems = payload['items'] ?? payload['cartItems'] ?? [];
    final items = <CartItemModel>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          items.add(CartItemModel.fromJson(item));
        } else if (item is Map) {
          items.add(CartItemModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    final estimatedSubtotal = items.fold<int>(
      0,
      (sum, item) => sum + (item.lineTotal ?? 0),
    );

    return CartModel(
      id: payload['id']?.toString() ?? payload['_id']?.toString(),
      items: items,
      subtotal: _asInt(payload['subtotal']) ?? estimatedSubtotal,
      tax: _asInt(payload['tax']) ?? 0,
      total: _asInt(payload['total']) ??
          ((_asInt(payload['subtotal']) ?? estimatedSubtotal) +
              (_asInt(payload['tax']) ?? 0)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items?.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
    };
  }

  CartEntity toEntity() {
    final mappedItems = items?.map((e) => e.toEntity()).toList() ?? [];
    final estimatedSubtotal =
        mappedItems.fold<int>(0, (sum, item) => sum + item.lineTotal);
    final mappedTax = tax ?? 0;

    return CartEntity(
      id: id ?? '',
      items: mappedItems,
      subtotal: subtotal ?? estimatedSubtotal,
      tax: mappedTax,
      total: total ?? ((subtotal ?? estimatedSubtotal) + mappedTax),
    );
  }

  static bool looksLikeCart(dynamic data) {
    if (data is! Map) return false;
    final payload = _unwrapCartJson(Map<String, dynamic>.from(data));
    return payload.containsKey('items') ||
        payload.containsKey('cartItems') ||
        payload.containsKey('subtotal') ||
        payload.containsKey('total');
  }
}

Map<String, dynamic> _unwrapCartJson(Map<String, dynamic> json) {
  final data = json['data'];
  if (data is Map<String, dynamic>) {
    if (data['cart'] is Map<String, dynamic>) {
      return data['cart'] as Map<String, dynamic>;
    }
    return data;
  }
  if (json['cart'] is Map<String, dynamic>) {
    return json['cart'] as Map<String, dynamic>;
  }
  return json;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  return int.tryParse(value.toString()) ??
      double.tryParse(value.toString())?.round();
}
