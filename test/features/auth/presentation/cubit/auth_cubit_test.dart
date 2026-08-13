import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/auth/domain/usecase/get_current_user_data_usecase.dart';
import 'package:dineflow/features/auth/domain/usecase/login_usecase.dart';
import 'package:dineflow/features/auth/domain/usecase/logout_usecase.dart';
import 'package:dineflow/features/auth/domain/usecase/register_usecase.dart';
import 'package:dineflow/features/auth/presintation/view_mode/cubit/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeLoginUseCase implements LoginUseCase {
  Result<UserEntity>? resultToReturn;

  @override
  Future<Result<UserEntity>> call(LoginParams params) async {
    return resultToReturn!;
  }
}

class FakeRegisterUseCase implements RegisterUseCase {
  Result<UserEntity>? resultToReturn;

  @override
  Future<Result<UserEntity>> call(RegisterParams params) async {
    return resultToReturn!;
  }
}

class FakeLogoutUseCase implements LogoutUseCase {
  Result<void>? resultToReturn;

  @override
  Future<Result<void>> call(NoParams params) async {
    return resultToReturn!;
  }
}

class FakeGetCurrentUserDataUseCase implements GetCurrentUserDataUseCase {
  Result<UserEntity?>? resultToReturn;

  @override
  Future<Result<UserEntity?>> call(NoParams params) async {
    return resultToReturn!;
  }
}

void main() {
  late AuthCubit cubit;
  late FakeLoginUseCase fakeLoginUseCase;
  late FakeRegisterUseCase fakeRegisterUseCase;
  late FakeLogoutUseCase fakeLogoutUseCase;
  late FakeGetCurrentUserDataUseCase fakeGetCurrentUserDataUseCase;

  final tUser = const UserEntity(
    id: '123',
    name: 'Test User',
    email: 'test@example.com',
    role: UserRole.customer,
  );

  setUp(() {
    fakeLoginUseCase = FakeLoginUseCase();
    fakeRegisterUseCase = FakeRegisterUseCase();
    fakeLogoutUseCase = FakeLogoutUseCase();
    fakeGetCurrentUserDataUseCase = FakeGetCurrentUserDataUseCase();

    cubit = AuthCubit(
      fakeLoginUseCase,
      fakeRegisterUseCase,
      fakeLogoutUseCase,
      fakeGetCurrentUserDataUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be AuthState.initial()', () {
    expect(cubit.state, equals(const AuthState.initial()));
  });

  group('login', () {
    test('emits [loading, authenticated] when login succeeds', () async {
      fakeLoginUseCase.resultToReturn = Success(tUser);

      final expectedStates = [
        const AuthState.loading(),
        AuthState.authenticated(tUser),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.login(const LoginParams(
        email: 'test@example.com',
        password: 'password',
      ));
    });

    test('emits [loading, error] when login fails', () async {
      fakeLoginUseCase.resultToReturn = const FailureResult(
        ServerFailure('Invalid credentials'),
      );

      final expectedStates = [
        const AuthState.loading(),
        const AuthState.error('Invalid credentials'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.login(const LoginParams(
        email: 'test@example.com',
        password: 'wrongpassword',
      ));
    });
  });

  group('register', () {
    test('emits [loading, authenticated] when register succeeds', () async {
      fakeRegisterUseCase.resultToReturn = Success(tUser);

      final expectedStates = [
        const AuthState.loading(),
        AuthState.authenticated(tUser),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.register(const RegisterParams(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password',
      ));
    });

    test('emits [loading, error] when register fails', () async {
      fakeRegisterUseCase.resultToReturn = const FailureResult(
        ServerFailure('Email already in use'),
      );

      final expectedStates = [
        const AuthState.loading(),
        const AuthState.error('Email already in use'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.register(const RegisterParams(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password',
      ));
    });
  });

  group('logout', () {
    test('emits [loading, unauthenticated] when logout succeeds', () async {
      fakeLogoutUseCase.resultToReturn = const Success(null);

      final expectedStates = [
        const AuthState.loading(),
        const AuthState.unauthenticated(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.logout();
    });

    test('emits [loading, error] when logout fails', () async {
      fakeLogoutUseCase.resultToReturn = const FailureResult(
        ServerFailure('Logout failed'),
      );

      final expectedStates = [
        const AuthState.loading(),
        const AuthState.error('Logout failed'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.logout();
    });
  });

  group('getCurrentUserData', () {
    test('emits [loading, authenticated] when user data exists', () async {
      fakeGetCurrentUserDataUseCase.resultToReturn = Success(tUser);

      final expectedStates = [
        const AuthState.loading(),
        AuthState.authenticated(tUser),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.getCurrentUserData();
    });

    test('emits [loading, unauthenticated] when user data is null', () async {
      fakeGetCurrentUserDataUseCase.resultToReturn = const Success(null);

      final expectedStates = [
        const AuthState.loading(),
        const AuthState.unauthenticated(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.getCurrentUserData();
    });

    test('emits [loading, error] when getCurrentUserData fails', () async {
      fakeGetCurrentUserDataUseCase.resultToReturn = const FailureResult(
        ServerFailure('Failed to fetch user data'),
      );

      final expectedStates = [
        const AuthState.loading(),
        const AuthState.error('Failed to fetch user data'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.getCurrentUserData();
    });
  });
}
