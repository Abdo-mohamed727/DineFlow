// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dineflow/core/di/firebase_module.dart' as _i297;
import 'package:dineflow/core/di/router_module.dart' as _i1038;
import 'package:dineflow/core/router/route_guard.dart' as _i696;
import 'package:dineflow/features/auth/data/data_source/auth_remote_data_source_impl.dart'
    as _i784;
import 'package:dineflow/features/auth/data/data_source/auth_remote_data_source_interface.dart'
    as _i207;
import 'package:dineflow/features/auth/data/repo/auth_repository_impl.dart'
    as _i764;
import 'package:dineflow/features/auth/domain/repo/auth_repository_interface.dart'
    as _i821;
import 'package:dineflow/features/auth/domain/usecase/get_current_user_data_usecase.dart'
    as _i1047;
import 'package:dineflow/features/auth/domain/usecase/login_usecase.dart'
    as _i681;
import 'package:dineflow/features/auth/domain/usecase/logout_usecase.dart'
    as _i241;
import 'package:dineflow/features/auth/domain/usecase/register_usecase.dart'
    as _i1;
import 'package:dineflow/features/auth/presintation/view_mode/cubit/auth_cubit.dart'
    as _i87;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    final routerModule = _$RouterModule();
    gh.singleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.singleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.singleton<_i696.RouterNotifier>(() => routerModule.routerNotifier);
    gh.lazySingleton<_i207.AuthRemoteDataSource>(
      () => _i784.AuthRemoteDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i821.AuthRepositoryInterface>(
      () => _i764.AuthRepositoryImpl(gh<_i207.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i1047.GetCurrentUserDataUseCase>(
      () =>
          _i1047.GetCurrentUserDataUseCase(gh<_i821.AuthRepositoryInterface>()),
    );
    gh.lazySingleton<_i681.LoginUseCase>(
      () => _i681.LoginUseCase(gh<_i821.AuthRepositoryInterface>()),
    );
    gh.lazySingleton<_i241.LogoutUseCase>(
      () => _i241.LogoutUseCase(gh<_i821.AuthRepositoryInterface>()),
    );
    gh.lazySingleton<_i1.RegisterUseCase>(
      () => _i1.RegisterUseCase(gh<_i821.AuthRepositoryInterface>()),
    );
    gh.factory<_i87.AuthCubit>(
      () => _i87.AuthCubit(
        gh<_i681.LoginUseCase>(),
        gh<_i1.RegisterUseCase>(),
        gh<_i241.LogoutUseCase>(),
        gh<_i1047.GetCurrentUserDataUseCase>(),
      ),
    );
    return this;
  }
}

class _$FirebaseModule extends _i297.FirebaseModule {}

class _$RouterModule extends _i1038.RouterModule {}
