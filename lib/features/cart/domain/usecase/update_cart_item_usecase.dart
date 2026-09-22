import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:dineflow/features/cart/domain/repo/cart_repository_interface.dart';
import 'package:injectable/injectable.dart';

final class UpdateCartItemParams {
  final String productId;
  final int quantity;

  const UpdateCartItemParams({
    required this.productId,
    required this.quantity,
  });
}

@lazySingleton
class UpdateCartItemUseCase
    implements UseCase<Result<CartEntity>, UpdateCartItemParams> {
  final CartRepositoryInterface _repository;

  const UpdateCartItemUseCase(this._repository);

  @override
  Future<Result<CartEntity>> call(UpdateCartItemParams params) {
    return _repository.updateItem(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}
