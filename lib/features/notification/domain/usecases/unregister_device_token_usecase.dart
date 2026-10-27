import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/notification/domain/repo/notification_repo_interface.dart';
import 'package:injectable/injectable.dart';

class UnregisterDeviceTokenParams {
  final String token;

  const UnregisterDeviceTokenParams({
    required this.token,
  });
}

@lazySingleton
class UnregisterDeviceTokenUseCase
    implements UseCase<Result<void>, UnregisterDeviceTokenParams> {
  final NotificationRepoInterface _repository;

  UnregisterDeviceTokenUseCase(this._repository);

  @override
  Future<Result<void>> call(UnregisterDeviceTokenParams params) {
    return _repository.unregisterDeviceToken(params.token);
  }
}
