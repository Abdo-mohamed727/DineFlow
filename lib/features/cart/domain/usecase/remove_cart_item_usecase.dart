import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:dineflow/features/cart/domain/repo/cart_repository_interface.dart';
import 'package:injectable/injectable.dart';

final class RemoveCartItemParams {
  final String productId;

  const RemoveCartItemParams({required this.productId});
}

@lazySingleton
class RemoveCartItemUseCase
    implements UseCase<Result<CartEntity>, RemoveCartItemParams> {
  final CartRepositoryInterface _repository;

  const RemoveCartItemUseCase(this._repository);

  @override
  Future<Result<CartEntity>> call(RemoveCartItemParams params) {
    return _repository.removeItem(params.productId);
  }
}
