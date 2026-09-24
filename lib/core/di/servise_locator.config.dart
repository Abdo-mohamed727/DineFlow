// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dineflow/core/di/router_module.dart' as _i1038;
import 'package:dineflow/core/di/third_party_module.dart' as _i425;
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
import 'package:dineflow/features/cart/data/data_source/cart_remote_data_source_impl.dart'
    as _i991;
import 'package:dineflow/features/cart/data/data_source/cart_remote_data_source_interface.dart'
    as _i692;
import 'package:dineflow/features/cart/data/repo/cart_repository_impl.dart'
    as _i729;
import 'package:dineflow/features/cart/domain/repo/cart_repository_interface.dart'
    as _i652;
import 'package:dineflow/features/cart/domain/usecase/add_to_cart_usecase.dart'
    as _i589;
import 'package:dineflow/features/cart/domain/usecase/clear_cart_usecase.dart'
    as _i534;
import 'package:dineflow/features/cart/domain/usecase/get_cart_usecase.dart'
    as _i453;
import 'package:dineflow/features/cart/domain/usecase/remove_cart_item_usecase.dart'
    as _i139;
import 'package:dineflow/features/cart/domain/usecase/update_cart_item_usecase.dart'
    as _i351;
import 'package:dineflow/features/cart/presentation/view_model/cubit/cart_cubit.dart'
    as _i137;
import 'package:dineflow/features/menu/data/data_source/menu_remote_data_source_impl.dart'
    as _i853;
import 'package:dineflow/features/menu/data/data_source/menu_remote_data_source_interface.dart'
    as _i944;
import 'package:dineflow/features/menu/data/repo/menu_repository_impl.dart'
    as _i591;
import 'package:dineflow/features/menu/domain/repo/menu_repository_interface.dart'
    as _i1012;
import 'package:dineflow/features/menu/domain/usecase/get_categories_usecase.dart'
    as _i492;
import 'package:dineflow/features/menu/domain/usecase/get_products_usecase.dart'
    as _i1;
import 'package:dineflow/features/menu/domain/usecase/search_products_usecase.dart'
    as _i1028;
import 'package:dineflow/features/menu/presentation/view_model/cubit/menu_cubit.dart'
    as _i1064;
import 'package:dineflow/features/orders/data/data_source/order_remote_data_source_impl.dart'
    as _i240;
import 'package:dineflow/features/orders/data/data_source/order_remote_data_source_interface.dart'
    as _i146;
import 'package:dineflow/features/orders/data/repo/order_repository_impl.dart'
    as _i971;
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart'
    as _i300;
import 'package:dineflow/features/orders/domain/usecase/create_dine_in_order_usecase.dart'
    as _i440;
import 'package:dineflow/features/orders/domain/usecase/create_take_away_order_usecase.dart'
    as _i173;
import 'package:dineflow/features/orders/domain/usecase/get_available_tables_usecase.dart'
    as _i181;
import 'package:dineflow/features/orders/domain/usecase/start_dining_usecase.dart'
    as _i279;
import 'package:dineflow/features/orders/presentation/view_model/cubit/checkout_cubit.dart'
    as _i713;
import 'package:dineflow/features/profile/data/data_source/profile_remote_data_source_impl.dart'
    as _i485;
import 'package:dineflow/features/profile/data/data_source/profile_remote_data_source_interface.dart'
    as _i752;
import 'package:dineflow/features/profile/data/repo/profile_repository_impl.dart'
    as _i491;
import 'package:dineflow/features/profile/domain/repo/profile_repository_interface.dart'
    as _i995;
import 'package:dineflow/features/profile/domain/usecase/get_profile_usecase.dart'
    as _i831;
import 'package:dineflow/features/profile/domain/usecase/update_profile_usecase.dart'
    as _i922;
import 'package:dineflow/features/profile/presintation/view_model/cubit/profile_cubit.dart'
    as _i87;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final routerModule = _$RouterModule();
    final thirdPartyModule = _$ThirdPartyModule();
    gh.singleton<_i696.RouterNotifier>(() => routerModule.routerNotifier);
    gh.lazySingleton<_i361.Dio>(() => thirdPartyModule.dio);
    gh.lazySingleton<_i944.MenuRemoteDataSource>(
      () => _i853.MenuRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i207.AuthRemoteDataSource>(
      () => _i784.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i752.ProfileRemoteDataSourceInterface>(
      () => _i485.ProfileRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i146.OrderRemoteDataSource>(
      () => _i240.OrderRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i692.CartRemoteDataSource>(
      () => _i991.CartRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1012.MenuRepositoryInterface>(
      () => _i591.MenuRepositoryImpl(gh<_i944.MenuRemoteDataSource>()),
    );
    gh.lazySingleton<_i300.OrderRepositoryInterface>(
      () => _i971.OrderRepositoryImpl(gh<_i146.OrderRemoteDataSource>()),
    );
    gh.lazySingleton<_i652.CartRepositoryInterface>(
      () => _i729.CartRepositoryImpl(gh<_i692.CartRemoteDataSource>()),
    );
    gh.lazySingleton<_i995.ProfileRepositoryInterface>(
      () => _i491.ProfileRepositoryImpl(
        gh<_i752.ProfileRemoteDataSourceInterface>(),
      ),
    );
    gh.lazySingleton<_i589.AddToCartUseCase>(
      () => _i589.AddToCartUseCase(gh<_i652.CartRepositoryInterface>()),
    );
    gh.lazySingleton<_i534.ClearCartUseCase>(
      () => _i534.ClearCartUseCase(gh<_i652.CartRepositoryInterface>()),
    );
    gh.lazySingleton<_i453.GetCartUseCase>(
      () => _i453.GetCartUseCase(gh<_i652.CartRepositoryInterface>()),
    );
    gh.lazySingleton<_i139.RemoveCartItemUseCase>(
      () => _i139.RemoveCartItemUseCase(gh<_i652.CartRepositoryInterface>()),
    );
    gh.lazySingleton<_i351.UpdateCartItemUseCase>(
      () => _i351.UpdateCartItemUseCase(gh<_i652.CartRepositoryInterface>()),
    );
    gh.lazySingleton<_i821.AuthRepositoryInterface>(
      () => _i764.AuthRepositoryImpl(gh<_i207.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i137.CartCubit>(
      () => _i137.CartCubit(
        gh<_i453.GetCartUseCase>(),
        gh<_i589.AddToCartUseCase>(),
        gh<_i351.UpdateCartItemUseCase>(),
        gh<_i139.RemoveCartItemUseCase>(),
        gh<_i534.ClearCartUseCase>(),
      ),
    );
    gh.lazySingleton<_i492.GetCategoriesUseCase>(
      () => _i492.GetCategoriesUseCase(gh<_i1012.MenuRepositoryInterface>()),
    );
    gh.lazySingleton<_i1.GetProductsUseCase>(
      () => _i1.GetProductsUseCase(gh<_i1012.MenuRepositoryInterface>()),
    );
    gh.lazySingleton<_i1028.SearchProductsUseCase>(
      () => _i1028.SearchProductsUseCase(gh<_i1012.MenuRepositoryInterface>()),
    );
    gh.lazySingleton<_i440.CreateDineInOrderUsecase>(
      () =>
          _i440.CreateDineInOrderUsecase(gh<_i300.OrderRepositoryInterface>()),
    );
    gh.lazySingleton<_i173.CreateTakeAwayOrderUsecase>(
      () => _i173.CreateTakeAwayOrderUsecase(
        gh<_i300.OrderRepositoryInterface>(),
      ),
    );
    gh.lazySingleton<_i181.GetAvailableTablesUseCase>(
      () =>
          _i181.GetAvailableTablesUseCase(gh<_i300.OrderRepositoryInterface>()),
    );
    gh.lazySingleton<_i279.StartDiningUseCase>(
      () => _i279.StartDiningUseCase(gh<_i300.OrderRepositoryInterface>()),
    );
    gh.factory<_i713.CheckoutCubit>(
      () => _i713.CheckoutCubit(
        gh<_i173.CreateTakeAwayOrderUsecase>(),
        gh<_i440.CreateDineInOrderUsecase>(),
        gh<_i181.GetAvailableTablesUseCase>(),
        gh<_i279.StartDiningUseCase>(),
      ),
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
    gh.lazySingleton<_i831.GetProfileUseCase>(
      () => _i831.GetProfileUseCase(gh<_i995.ProfileRepositoryInterface>()),
    );
    gh.lazySingleton<_i922.UpdateProfileUseCase>(
      () => _i922.UpdateProfileUseCase(gh<_i995.ProfileRepositoryInterface>()),
    );
    gh.factory<_i1064.MenuCubit>(
      () => _i1064.MenuCubit(
        gh<_i492.GetCategoriesUseCase>(),
        gh<_i1.GetProductsUseCase>(),
        gh<_i1028.SearchProductsUseCase>(),
      ),
    );
    gh.factory<_i87.ProfileCubit>(
      () => _i87.ProfileCubit(
        gh<_i831.GetProfileUseCase>(),
        gh<_i922.UpdateProfileUseCase>(),
      ),
    );
    gh.lazySingleton<_i87.AuthCubit>(
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

class _$RouterModule extends _i1038.RouterModule {}

class _$ThirdPartyModule extends _i425.ThirdPartyModule {}
