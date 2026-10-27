import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:dineflow/features/cart/domain/repo/cart_repository_interface.dart';
import 'package:injectable/injectable.dart';

final class AddToCartParams {
  final String productId;
  final int quantity;

  const AddToCartParams({
    required this.productId,
    this.quantity = 1,
  });
}

@lazySingleton
class AddToCartUseCase
    implements UseCase<Result<CartEntity>, AddToCartParams> {
  final CartRepositoryInterface _repository;

  const AddToCartUseCase(this._repository);

  @override
  Future<Result<CartEntity>> call(AddToCartParams params) {
    return _repository.addItem(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}
