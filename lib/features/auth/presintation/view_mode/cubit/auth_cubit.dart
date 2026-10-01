import 'package:dineflow/core/services/notification/fcm_token_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/auth/domain/usecase/get_current_user_data_usecase.dart';
import 'package:dineflow/features/auth/domain/usecase/login_usecase.dart';
import 'package:dineflow/features/auth/domain/usecase/logout_usecase.dart';
import 'package:dineflow/features/auth/domain/usecase/register_usecase.dart';
 import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserDataUseCase _getCurrentUserDataUseCase;
  final FcmTokenManager _fcmTokenManager;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getCurrentUserDataUseCase,
    this._fcmTokenManager,
  ) : super(const AuthState.initial());

  Future<void> login(LoginParams params) async {
    emit(const AuthState.loading());
    final result = await _loginUseCase(params);
    switch (result) {
      case Success(data: final user):
        _fcmTokenManager.registerFCMToken();
        emit(AuthState.authenticated(user));
      case FailureResult(failure: final failure):
        emit(AuthState.error(failure.message));
    }
  }

  Future<void> register(RegisterParams params) async {
    emit(const AuthState.loading());
    final result = await _registerUseCase(params);
    switch (result) {
      case Success(data: final user):
        _fcmTokenManager.registerFCMToken();
        emit(AuthState.authenticated(user));
      case FailureResult(failure: final failure):
        emit(AuthState.error(failure.message));
    }
  }

  Future<void> logout() async {
    emit(const AuthState.loading());
    final result = await _logoutUseCase(const NoParams());
    switch (result) {
      case Success():
        _fcmTokenManager.unregisterFCMToken();
        emit(const AuthState.unauthenticated());
      case FailureResult(failure: final failure):
        emit(AuthState.error(failure.message));
    }
  }

  Future<void> getCurrentUserData() async {
    emit(const AuthState.loading());
    final result = await _getCurrentUserDataUseCase(const NoParams());
    switch (result) {
      case Success(data: final user):
        if (user != null) {
          _fcmTokenManager.registerFCMToken();
          emit(AuthState.authenticated(user));
        } else {
          emit(const AuthState.unauthenticated());
        }
      case FailureResult(failure: final failure):
        emit(AuthState.error(failure.message));
    }
  }
}

