import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/usecase/get_available_tables_usecase.dart';
import 'package:dineflow/features/orders/domain/usecase/place_order_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'checkout_state.dart';
part 'checkout_cubit.freezed.dart';

@injectable
class CheckoutCubit extends Cubit<CheckoutState> {
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetAvailableTablesUseCase _getAvailableTablesUseCase;

  CheckoutCubit(
    this._placeOrderUseCase,
    this._getAvailableTablesUseCase,
  ) : super(const CheckoutState.initial());

  Future<void> selectOrderType(OrderType type) async {
    final current = state;
    if (current is! _CheckoutInitial) return;

    emit(
      current.copyWith(
        orderType: type,
        errorMessage: null,
        selectedTableId: type == OrderType.takeaway
            ? null
            : current.selectedTableId,
      ),
    );

    if (type == OrderType.dineIn && current.tables.isEmpty) {
      await loadTables();
    }
  }

  Future<void> loadTables() async {
    final current = state;
    if (current is! _CheckoutInitial) return;

    emit(current.copyWith(isLoadingTables: true, errorMessage: null));
    final result = await _getAvailableTablesUseCase(const NoParams());
    final latest = state;
    if (latest is! _CheckoutInitial) return;

    switch (result) {
      case Success(data: final tables):
        emit(
          latest.copyWith(
            tables: tables,
            isLoadingTables: false,
            selectedTableId: tables.any((t) => t.id == latest.selectedTableId)
                ? latest.selectedTableId
                : null,
          ),
        );
      case FailureResult(failure: final failure):
        emit(
          latest.copyWith(
            isLoadingTables: false,
            errorMessage: failure.message,
          ),
        );
    }
  }

  void selectTable(String tableId) {
    final current = state;
    if (current is! _CheckoutInitial) return;
    emit(current.copyWith(selectedTableId: tableId, errorMessage: null));
  }

  Future<void> placeOrder() async {
    final current = state;
    if (current is! _CheckoutInitial) return;
    if (current.isPlacingOrder) return;

    final orderType = current.orderType;
    if (orderType == null) {
      emit(current.copyWith(errorMessage: 'Please choose an order type.'));
      return;
    }

    if (orderType == OrderType.dineIn &&
        (current.selectedTableId == null || current.selectedTableId!.isEmpty)) {
      emit(current.copyWith(errorMessage: 'Please select an available table.'));
      return;
    }

    emit(current.copyWith(isPlacingOrder: true, errorMessage: null));

    final result = await _placeOrderUseCase(
      PlaceOrderParams(
        orderType: orderType.apiValue,
        tableId: orderType == OrderType.dineIn ? current.selectedTableId : null,
      ),
    );

    switch (result) {
      case Success(data: final order):
        emit(CheckoutState.success(order));
      case FailureResult(failure: final failure):
        final latest = state;
        if (latest is _CheckoutInitial) {
          emit(
            latest.copyWith(
              isPlacingOrder: false,
              errorMessage: _friendlyOrderError(failure),
            ),
          );
        }
    }
  }

  String _friendlyOrderError(Failure failure) {
    if (failure is AuthFailure) {
      return 'Please log in again to place your order.';
    }
    if (failure is NetworkFailure) {
      return failure.message;
    }
    return failure.message;
  }
}
