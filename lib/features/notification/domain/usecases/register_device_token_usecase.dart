import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/notification/domain/repo/notification_repo_interface.dart';
import 'package:injectable/injectable.dart';

class RegisterDeviceTokenParams {
  final String token;

  const RegisterDeviceTokenParams({
    required this.token,
  });
}

@lazySingleton
class RegisterDeviceTokenUseCase
    implements UseCase<Result<void>, RegisterDeviceTokenParams> {
  final NotificationRepoInterface _repository;

  RegisterDeviceTokenUseCase(this._repository);

  @override
  Future<Result<void>> call(RegisterDeviceTokenParams params) {
    return _repository.registerDeviceToken(params.token);
  }
}
