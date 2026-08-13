import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:dineflow/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
  ) : super(const ProfileState.initial());

  Future<void> getProfile() async {
    emit(const ProfileState.loading());
    final result = await _getProfileUseCase(const NoParams());
    switch (result) {
      case Success(data: final user):
        emit(ProfileState.loaded(user));
      case FailureResult(failure: final failure):
        emit(ProfileState.error(failure.message));
    }
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    emit(const ProfileState.loading());
    final result = await _updateProfileUseCase(params);
    switch (result) {
      case Success(data: final user):
        emit(ProfileState.updateSuccess(user));
      case FailureResult(failure: final failure):
        emit(ProfileState.error(failure.message));
    }
  }
}
