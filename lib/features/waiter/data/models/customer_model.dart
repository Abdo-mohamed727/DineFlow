import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';

class CustomerModel {
  final String id;
  final String name;

  const CustomerModel({
    required this.id,
    required this.name,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      name: name,
    );
  }
}