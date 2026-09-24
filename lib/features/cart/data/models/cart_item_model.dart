import 'package:dineflow/features/cart/domain/entites/cart_item_entity.dart';

class CartItemModel {
  Data? data;

  CartItemModel({this.data});

  CartItemModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() => {if (data != null) 'data': data!.toJson()};

  CartEntity toEntity() => data?.cart?.toEntity() ?? CartEntity.empty;
}

class Data {
  Cart? cart;

  Data({this.cart});

  Data.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? Cart.fromJson(json['cart']) : null;
  }

  Map<String, dynamic> toJson() => {if (cart != null) 'cart': cart!.toJson()};
}

class Cart {
  String? id;
  List<Items>? items;
  int? subtotal;
  double? taxRate;
  double? tax;
  double? total;
  int? itemCount;

  Cart({
    this.id,
    this.items,
    this.subtotal,
    this.taxRate,
    this.tax,
    this.total,
    this.itemCount,
  });

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) => items!.add(Items.fromJson(v)));
    }
    subtotal = json['subtotal'];
    taxRate = (json['taxRate'] as num?)?.toDouble();
    tax = (json['tax'] as num?)?.toDouble();
    total = (json['total'] as num?)?.toDouble();
    itemCount = json['itemCount'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (items != null) 'items': items!.map((v) => v.toJson()).toList(),
    'subtotal': subtotal,
    'taxRate': taxRate,
    'tax': tax,
    'total': total,
    'itemCount': itemCount,
  };

  CartEntity toEntity() => CartEntity(
    id: id ?? '',
    items: items?.map((e) => e.toEntity()).toList() ?? const [],
    subtotal: subtotal ?? 0,
    taxRate: taxRate ?? 0,
    tax: tax ?? 0,
    total: total ?? 0,
    itemCount: itemCount ?? 0,
  );
}

class Items {
  String? productId;
  String? name;
  int? price;
  String? image;
  bool? isAvailable;
  int? quantity;
  int? subtotal;

  Items({
    this.productId,
    this.name,
    this.price,
    this.image,
    this.isAvailable,
    this.quantity,
    this.subtotal,
  });

  Items.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    isAvailable = json['isAvailable'];
    quantity = json['quantity'];
    subtotal = json['subtotal'];
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'price': price,
    'image': image,
    'isAvailable': isAvailable,
    'quantity': quantity,
    'subtotal': subtotal,
  };

  CartItemEntity toEntity() => CartItemEntity(
    productId: productId ?? '',
    name: name ?? '',
    price: price ?? 0,
    image: image ?? '',
    isAvailable: isAvailable ?? false,
    quantity: quantity ?? 0,
    subtotal: subtotal ?? 0,
  );
}
