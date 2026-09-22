import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:dineflow/features/cart/domain/repo/cart_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ClearCartUseCase implements UseCase<Result<CartEntity>, NoParams> {
  final CartRepositoryInterface _repository;

  const ClearCartUseCase(this._repository);

  @override
  Future<Result<CartEntity>> call(NoParams params) {
    return _repository.clearCart();
  }
}
